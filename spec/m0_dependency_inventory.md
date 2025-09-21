# M0 Dependency Inventory

> **Instructions:** Catalog every library, module, and external asset required to build the Orca Slicer core for iOS. Update the status column as progress is made. Use “Green” when confirmed iOS-ready, “Yellow” when investigation is ongoing, and “Red” when a blocker exists. Link detailed notes or tickets where applicable.

| Component | Location / Target | Type (Static/Shared/Header-only) | License | iOS Compatibility Notes | Current Status (G/Y/R) | Owner | Planned Mitigation | Target Milestone |
|-----------|-------------------|----------------------------------|---------|------------------------|------------------------|-------|--------------------|------------------|
| OrcaSlicer Core (`libslic3r`) | `src/libslic3r` | Static | AGPLv3 (project license) | Heavy use of filesystem, threading, and SIMD paths; needs iOS toolchain configuration and feature gating for wxWidgets hooks | Yellow | Core Packaging | Stand up dedicated iOS CMake toolchain; stub wxWidgets-dependent code paths | M2 |
| Boost (selected modules) | `deps/Boost` | Header + Static (filesystem, program_options) | Boost Software License 1.0 | Majority header-only; must disable unsupported components (locale, python) and ensure `boost::filesystem` maps to libc++ on iOS | Yellow | Core Packaging | Prune build to header-only libs + filesystem; validate with clang `-target arm64-apple-ios` | M1 |
| oneTBB | `deps/TBB` | Static | Apache 2.0 with LLVM exception | Upstream CMake does not ship iOS presets; requires custom toolchain and disabling deprecated GNU atomics | Red | Core Packaging | Evaluate community iOS patches; consider replacing with libdispatch-backed task scheduler | M2 |
| OpenVDB | `deps/OpenVDB` | Static | MPL 2.0 | Depends on TBB, Blosc, OpenEXR; large footprint and limited benefit for Phase 1 FDM workflows | Red | Core Packaging | Exclude from iOS package for Phase 1; document feature loss (volumetric supports) | M2 |
| GMP | `deps/GMP` | Static | GPLv3 | Assembly kernels for x86/ARM Linux fail under `arm64-apple-ios`; needs hand-tuned build scripts | Red | Core Packaging | Investigate prebuilt universal binaries or leverage Boost.Multiprecision fallback | M3 |
| MPFR | `deps/MPFR` | Static | LGPLv3 | Requires GMP; build system lacks iOS target awareness; used for STEP/curve tooling | Red | Core Packaging | Defer STEP import on iOS; pursue rational approximation fallback before reenabling | M3 |
| CGAL | `deps/CGAL` | Header-only + Static utilities | GPLv3/LGPLv3 | Template-heavy; depends on GMP/MPFR; pure header portions compile but kernel selection must avoid Qt/OpenGL hooks | Yellow | Core Packaging | Configure `CGAL_HEADER_ONLY=ON`; gate functionality needing exact arithmetic | M2 |
| cURL | `deps/CURL` | Static | MIT | Needs Secure Transport backend instead of OpenSSL; current build scripts assume OpenSSL everywhere | Yellow | Core Packaging | Build with `-DCURL_USE_SECTRANSP=ON`; drop unused protocols | M2 |
| OpenSSL | `deps/OpenSSL` | Static | Apache 2.0 | Requires separate builds for simulator/device; upstream provides `ios` script but not integrated | Yellow | Core Packaging | Automate via `./Configure ios64-simulator` & `ios64-cross`; evaluate replacing with platform Security APIs | M2 |
| Eigen | `deps/` (via submodule) | Header-only | MPL 2.0 | Fully header-only; no platform-specific code | Green | Core Packaging | None | M1 |
| zlib | `deps/ZLIB` | Static | zlib | Portable C implementation; compiles under generic clang | Green | Core Packaging | Ensure `CMAKE_OSX_SYSROOT` provided when cross-compiling | M1 |
| wxWidgets | `deps/wxWidgets` | Static | wxWindows License | Desktop UI only; unused for core library but referenced in build; must be excluded from iOS configuration | Yellow | Core Packaging | Guard top-level CMake targets; confirm libslic3r does not link GUI artifacts | M1 |

- **Last Updated:** 2025-09-21 (Core Packaging Agent)
- **Reference Commands:**
  - `rg "find_package" -g"CMakeLists.txt"`
  - `cmake --graphviz=deps.dot` (visualize target relationships)

> **Reminder:** Record any licensing red flags separately for Quality Agent review.
