# M0 Packaging Experiments Log

> **Purpose:** Capture every packaging experiment run during M0 so the team can make a data-backed recommendation for how to ship the Orca Slicer core to iOS.

## 1. Experiment Summary Table
| Experiment ID | Date | Owner | Option Tested | Command(s) / Script | Outcome | Key Logs / Links | Follow-up |
|---------------|------|-------|---------------|---------------------|---------|------------------|-----------|
| P-001 | 2025-09-21 | Core Packaging Agent | Static `.a` via CMake cross-toolchain | `cmake -S deps -B build_ios_dep -DCMAKE_SYSTEM_NAME=iOS ...` | ❌ Failed – missing Apple SDK/compilers | `cmake` configure log | Provision macOS builder; retry with ios-cmake toolchain |
| P-002 | 2025-09-21 | Core Packaging Agent | `.xcframework` wrapper built from static libs | `xcodebuild -create-xcframework -library libOrcaCore.a ...` (planned) | ⚠️ Blocked – requires macOS host artifacts | Packaging design doc draft | Capture dependency graph for libs to include |
| P-003 | 2025-09-21 | Core Packaging Agent | SwiftPM binary target distribution | `swift package compute-checksum OrcaCore.xcframework` (planned) | ⚠️ Research only – evaluating feasibility | Notes in this doc | Align with Developer Experience on distribution |

## 2. Detailed Notes Template
```
### Experiment P-001 – Static `.a` via CMake cross-toolchain
- Environment:
  - Host: Debian container (no Apple SDK)
  - Toolchain: System CMake 3.28, GNU build-essential
  - Additional toolchains: None – attempted generic iOS configuration
- Commands executed:
  - `cmake -S OrcaSlicer/deps -B OrcaSlicer/build_ios_dep -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_OSX_ARCHITECTURES=arm64`
- Artifact produced (path, size): _None – configure stage failed_
- Issues observed:
  - CMake rejected `iphoneos` SDK due to absent Apple toolchain definitions.
  - `CMAKE_C_COMPILER`/`CMAKE_CXX_COMPILER` unset because clang with iOS sysroot was unavailable.【e1b58c†L1-L19】
- Mitigations attempted:
  - Reviewed community `ios-cmake` toolchain; concluded it must be vendored to proceed.
  - Identified requirement to install Apple SDK headers or run on macOS CI host.
- Recommendation / impact on decision:
  - Proceed with macOS-based build host for packaging; Linux container cannot produce artifacts without significant bootstrapping.

### Experiment P-002 – `.xcframework` assembly plan
- Environment:
  - Target host: macOS 14+ with Xcode 15 CLI tools (not available in container)
  - Toolchain: Planned use of CMake-produced static libs for simulator/device
  - Additional toolchains: `xcodebuild`, `lipo`
- Commands executed:
  - _Not executed in this environment; documented workflow only._
- Artifact produced (path, size): _Pending_
- Issues observed:
  - Need repeatable script to merge simulator + device archives; packaging must bundle headers + module map.
- Mitigations attempted:
  - Authored shell script outline using `xcodebuild -create-xcframework` once static libs exist.
- Recommendation / impact on decision:
  - Prefer `.xcframework` as final deliverable for Swift integration; requires follow-up once static libs built on macOS.

### Experiment P-003 – SwiftPM binary target investigation
- Environment:
  - Research only; relies on `.xcframework` artifact from P-002
  - Toolchain: Swift Package Manager (Xcode 15)
- Commands executed:
  - _Not executed yet; recorded steps to compute checksum and host artifact._
- Artifact produced (path, size): _Pending_
- Issues observed:
  - Hosting/distribution strategy unresolved; need to align with licensing for AGPL components.
- Mitigations attempted:
  - Drafted checklist for Developer Experience agent covering checksum automation and versioning.
- Recommendation / impact on decision:
  - Defer SwiftPM packaging until after `.xcframework` pipeline is validated; keep as stretch goal for Phase 1.
```

## 3. Open Questions
- Clarify whether OpenVDB-dependent functionality must ship in Phase 1 or can be deferred alongside volumetric features.
- Confirm legal review for distributing AGPL-licensed static libraries inside `.xcframework` bundles.
- Determine hosting location (self-hosted vs. Git LFS) for binary artifacts referenced by SwiftPM.

> **Reminder:** Attach relevant log files or CI job links where possible so future phases can reproduce the results.
