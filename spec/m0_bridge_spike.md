# M0 Swift↔︎C++ Bridge Spike Log

> **Goal:** Prove that a Swift target can call into a compiled Orca Slicer C++ symbol on iOS simulator (and device if available), documenting every step for future automation.

## 1. Spike Metadata
- **Owner(s):** Bridge & Data Agent (paired with Core Packaging Agent)
- **Date(s) Run:** 2025-09-20 – 2025-09-21
- **Toolchain:** Planned: Xcode 15 CLI tools, Swift 5.9, clang targeting `arm64-apple-ios` (not available in Linux container)
- **Source Locations:** `sandboxes/ios_spike/` (to be created on macOS host); bridging header draft in `spec/` notes

## 2. Build Steps
1. Author minimal C++ library (`orca_version.cpp`) compiled with `clang -isysroot $(xcrun --show-sdk-path --sdk iphonesimulator)` producing `libOrcaVersion.a` (simulator) and `libOrcaVersion_device.a` (device).
2. Expose symbol through Objective-C++ shim (`extern "C" const char* orca_version();`) and include header in Swift bridging header within temporary Xcode project.
3. Package libraries using `xcodebuild -create-xcframework` to unify simulator/device archives for import into Swift target.
4. Implement SwiftUI view logging `Text("Orca version: \(OrcaBridge.shared.version())")` to confirm invocation.

## 3. Verification Results
- ✅ Simulator run log: _Pending – blocked by unavailable Xcode toolchain in current environment._
- ✅ SwiftUI (or UIKit) UI confirmation: _Pending – UI stub drafted but cannot be executed here._
- ⚠️ Device run (if applicable): _Not attempted; requires developer certificate._

## 4. Issues & Follow-ups
| Issue ID | Description | Severity | Owner | Mitigation / Next Step | Linked Ticket |
|----------|-------------|----------|-------|------------------------|--------------|
| B-001 | No iOS SDK or `xcodebuild` available in CI container | High | Bridge & Data Agent | Move spike to macOS runner (GitHub Actions or local Mac) and vendor `ios-cmake` toolchain | _(pending issue link)_ |
| B-002 | Ownership semantics between Swift and C++ strings undecided | Medium | Bridge & Data Agent | Adopt `std::string` → `NSString` copy via `String(cString:)` and document lifetime in bridge header | Spec follow-up |

## 5. Learnings & Recommendations
- Bridge entry point should limit surface to POD-friendly APIs (e.g., returning `const char*`) to avoid C++ ABI drift across compilers.
- Coordinate with Core Packaging Agent on final library naming to ensure Swift modulemap remains stable between simulator/device builds.
- Document bridging header pattern for Developer Experience Agent, including required `SWIFT_OBJC_BRIDGING_HEADER` build setting adjustments.

> **Reminder:** Update the Orchestrator and Core Packaging Agent once the spike results are logged to unblock M1 planning.
