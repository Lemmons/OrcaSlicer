#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

: "${BUILD_CONFIG:=Release}"
: "${OSX_DEPLOYMENT_TARGET:=11.3}"
: "${CMAKE_BUILD_PARALLEL_LEVEL:=$(sysctl -n hw.ncpu 2>/dev/null || echo 8)}"
: "${SLICER_CMAKE_GENERATOR:=Ninja}"
: "${IOS_INCLUDE_SIMULATOR_X86_64:=0}"

IOS_TOOLCHAIN_DIR="${REPO_ROOT}/tools/ios-cmake"
IOS_TOOLCHAIN_FILE="${IOS_TOOLCHAIN_DIR}/ios.toolchain.cmake"

if [[ ! -f "${IOS_TOOLCHAIN_FILE}" ]]; then
    echo "ios-cmake toolchain was not found at ${IOS_TOOLCHAIN_FILE}" >&2
    echo "Make sure the toolchain is vendored under tools/ios-cmake." >&2
    exit 1
fi

BUILD_ROOT="${REPO_ROOT}/build/ios"
INSTALL_ROOT="${BUILD_ROOT}/install"
LOG_ROOT="${BUILD_ROOT}/logs"
mkdir -p "${BUILD_ROOT}" "${INSTALL_ROOT}" "${LOG_ROOT}"

# Map ios-cmake platforms to friendly directory names.
declare -a PLATFORM_MATRIX=(
    "iphoneos:OS64:iphoneos"
    "iphonesimulator-arm64:SIMULATORARM64:iphonesimulator"
)

if [[ "${IOS_INCLUDE_SIMULATOR_X86_64}" == "1" ]]; then
    PLATFORM_MATRIX+=("iphonesimulator-x86_64:SIMULATOR64:iphonesimulator")
fi

configure_and_build() {
    local name="$1"
    local platform="$2"
    local sdk="$3"

    local build_dir="${BUILD_ROOT}/${name}"
    local install_dir="${INSTALL_ROOT}/${name}"
    local log_prefix="${LOG_ROOT}/${name}"

    mkdir -p "${build_dir}" "${install_dir}"

    echo "Configuring ${name} (${platform})"
    cmake \
        -S "${REPO_ROOT}" \
        -B "${build_dir}" \
        -G "${SLICER_CMAKE_GENERATOR}" \
        -DCMAKE_TOOLCHAIN_FILE="${IOS_TOOLCHAIN_FILE}" \
        -DPLATFORM="${platform}" \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="${OSX_DEPLOYMENT_TARGET}" \
        -DCMAKE_BUILD_TYPE="${BUILD_CONFIG}" \
        -DCMAKE_INSTALL_PREFIX="${install_dir}" \
        -DSLIC3R_GUI=OFF \
        -DSLIC3R_STATIC=ON \
        -DSLIC3R_BUILD_SANDBOXES=OFF \
        -DBUILD_TESTS=OFF \
        -DSLIC3R_PROFILE=OFF \
        -DSLIC3R_PERL_XS=OFF \
        -DSLIC3R_PCH=OFF \
        -DORCA_TOOLS=OFF \
        -DSLIC3R_DESKTOP_INTEGRATION=OFF \
        2>&1 | tee "${log_prefix}-configure.log"

    echo "Building ${name}"
    cmake --build "${build_dir}" --config "${BUILD_CONFIG}" --target libslic3r libslic3r_cgal 2>&1 | tee "${log_prefix}-build.log"

    echo "Installing ${name}"
    cmake --install "${build_dir}" --config "${BUILD_CONFIG}" 2>&1 | tee "${log_prefix}-install.log"

    local -a libtool
    if command -v xcrun >/dev/null 2>&1; then
        libtool=(xcrun --sdk "${sdk}" libtool)
    else
        libtool=(libtool)
    fi

    local lib_dir="${install_dir}/lib"
    mkdir -p "${lib_dir}"

    shopt -s nullglob
    local -a existing_libs=("${lib_dir}"/lib*.a)
    shopt -u nullglob

    if [[ ${#existing_libs[@]} -eq 0 ]]; then
        echo "Syncing static libraries from build tree into ${lib_dir}"
        mapfile -t built_libs < <(find "${build_dir}" -path '*/CMakeFiles/*' -prune -o -name 'lib*.a' -print | sort)
        if [[ ${#built_libs[@]} -eq 0 ]]; then
            echo "Unable to locate static libraries for ${name} in ${build_dir}" >&2
            exit 1
        fi
        for lib in "${built_libs[@]}"; do
            cp "${lib}" "${lib_dir}/$(basename "${lib}")"
        done
    fi

    mapfile -t static_libs < <(find "${lib_dir}" -name 'libOrcaCore.a' -prune -o -name '*.a' -print | sort)
    if [[ ${#static_libs[@]} -eq 0 ]]; then
        echo "No static libraries were installed for ${name}; expected at least one." >&2
        exit 1
    fi

    local output_lib="${lib_dir}/libOrcaCore.a"
    echo "Creating ${output_lib}"
    "${libtool[@]}" -static -o "${output_lib}" "${static_libs[@]}" 2>&1 | tee "${log_prefix}-libtool.log"
}

for matrix_entry in "${PLATFORM_MATRIX[@]}"; do
    IFS=":" read -r build_name platform sdk <<<"${matrix_entry}"
    configure_and_build "${build_name}" "${platform}" "${sdk}"
done

cat <<INFO

Build summary:
  Build configuration : ${BUILD_CONFIG}
  macOS deployment    : ${OSX_DEPLOYMENT_TARGET}
  Generated outputs   :
$(find "${INSTALL_ROOT}" -name 'libOrcaCore.a' -print)
INFO
