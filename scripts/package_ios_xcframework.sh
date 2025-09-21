#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

: "${BUILD_CONFIG:=Release}"
: "${OSX_DEPLOYMENT_TARGET:=11.3}"

BUILD_ROOT="${REPO_ROOT}/build/ios"
INSTALL_ROOT="${BUILD_ROOT}/install"
LOG_ROOT="${BUILD_ROOT}/logs"
STAGING_ROOT="${BUILD_ROOT}/xcframework"
HEADER_ROOT="${STAGING_ROOT}/Headers"
ARTIFACT_ROOT="${BUILD_ROOT}/artifacts"
OUTPUT_NAME="OrcaCore.xcframework"
OUTPUT_PATH="${ARTIFACT_ROOT}/${OUTPUT_NAME}"

mkdir -p "${HEADER_ROOT}" "${ARTIFACT_ROOT}" "${LOG_ROOT}"

copy_headers() {
    local source_dir="${REPO_ROOT}/src/libslic3r"
    if command -v rsync >/dev/null 2>&1; then
        rsync -a --delete "${source_dir}/" "${HEADER_ROOT}/libslic3r/"
    else
        rm -rf "${HEADER_ROOT}/libslic3r"
        ditto "${source_dir}" "${HEADER_ROOT}/libslic3r"
    fi

    cat >"${HEADER_ROOT}/OrcaCore.h" <<'HDR'
#ifndef ORCA_CORE_H
#define ORCA_CORE_H

#include "libslic3r/libslic3r.h"

#endif // ORCA_CORE_H
HDR

    cat >"${HEADER_ROOT}/module.modulemap" <<'MODULEMAP'
module OrcaCore {
  umbrella header "OrcaCore.h"
  export *
}
MODULEMAP
}

require_lib() {
    local label="$1"
    local path="$2"
    if [[ ! -f "${path}" ]]; then
        echo "Missing static library for ${label} (${path}). Have you run build_ios_core.sh?" >&2
        exit 1
    fi
}

copy_headers

DEVICE_LIB="${INSTALL_ROOT}/iphoneos/lib/libOrcaCore.a"
SIM_ARM64_LIB="${INSTALL_ROOT}/iphonesimulator-arm64/lib/libOrcaCore.a"
SIM_X86_LIB="${INSTALL_ROOT}/iphonesimulator-x86_64/lib/libOrcaCore.a"

require_lib "iphoneos" "${DEVICE_LIB}"
require_lib "iphonesimulator-arm64" "${SIM_ARM64_LIB}"

xc_args=(
    -library "${DEVICE_LIB}" -headers "${HEADER_ROOT}"
    -library "${SIM_ARM64_LIB}" -headers "${HEADER_ROOT}"
)

if [[ -f "${SIM_X86_LIB}" ]]; then
    xc_args+=(-library "${SIM_X86_LIB}" -headers "${HEADER_ROOT}")
fi

rm -rf "${OUTPUT_PATH}"

xcodebuild -create-xcframework "${xc_args[@]}" -output "${OUTPUT_PATH}" \
    2>&1 | tee "${LOG_ROOT}/package.log"

echo "Created ${OUTPUT_PATH}"
