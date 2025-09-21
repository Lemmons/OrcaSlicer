# Orca Slicer iOS Port – Phase 1 Plan

## 1. Charter
- **Objective:** Deliver a Phase 1 iOS app that can view 3D models, reorient them, and invoke Orca Slicer’s engine via a Swift↔︎C++ bridge, enabling “slice on device” with default settings.
- **Core Goal:** Minimize changes to the upstream Orca Slicer codebase—prefer additive integrations and document any unavoidable modifications required for iOS support.
- **Success Criteria:**
  - Xcode project builds and runs on ARM64 simulator and device targets.
  - Orca Slicer core compiles into an iOS-ready library that responds to Swift bridge calls.
  - Users can load an STL, orient it on a virtual build plate, and trigger slicing with default settings.
- **Key Constraints:** Reuse existing Orca Slicer code, keep footprint minimal, target iOS 16+, and leverage SceneKit for accelerated 3D work.

## 2. Milestone Roadmap
1. **M0 – Project Setup & Discovery**
   - Inventory current CMake targets, dependencies, and licensing implications.
   - Decide packaging approach (static `.a` vs `.xcframework`).
   - Spike: verify a minimal C++ function can be invoked from Swift via bridging header.
2. **M1 – Buildable iOS Shell (SPEC-P1-001)**
   - Generate SwiftUI app skeleton with placeholder UI.
   - Establish repository layout for iOS artifacts (e.g., `ios/OrcaSlicerApp`).
3. **M2 – Orca Core Packaging (SPEC-P1-002)**
   - Produce reproducible cross-compilation scripts (CMake toolchain or Xcode project).
   - Validate library loads on simulator/device; document build instructions.
4. **M3 – Swift/C++ Bridge (SPEC-P1-003)**
   - Define bridging module and wrap an entry point such as `startSlicerEngine()`.
   - Add smoke test screen logging bridge call result.
5. **M4 – 3D Viewer Foundations (SPEC-P1-004 / SPEC-P1-005)**
   - Integrate SceneKit scene with default cube to verify rendering.
   - Implement STL import pipeline and mesh replacement in the viewer.
6. **M5 – Model Manipulation (SPEC-P1-006)**
   - Provide gesture/button controls for basic rotation/translation.
   - Implement “On Face” alignment heuristic and add a simple bed visualization.
7. **M6 – UI → Slicer Invocation (SPEC-P1-007)**
   - Wire Slice button to pass model and default config to C++ layer.
   - Display progress and success/failure status; log G-code output path.
8. **M7 – Hardening & Hand-off**
   - Wrap up documentation, build scripts, and initial QA checklist.
   - Capture lessons learned and blockers for Phase 2/3 planning.

## 3. Workstreams & Key Tasks

### A. Core Packaging & Tooling
- Audit Orca Slicer dependencies; identify iOS-incompatible components and optional features to disable.
- Author CMake toolchain or Xcode external build target for `arm64-apple-ios`.
- Establish automated build script (e.g., `scripts/build_ios_lib.sh`) that produces the binary and headers.
- Define the public API surface needed for Phase 1 deliverables.
- Provide sample Swift unit test or command-line harness to confirm symbol visibility.

### B. Swift Application Layer
- Decide on SwiftUI vs. UIKit (default to SwiftUI with a `SceneView` wrapper).
- Create module structure: `MainView`, `ModelViewerViewModel`, `SlicingService`.
- Implement file importer using `UIDocumentPickerViewController` or SwiftUI `FileImporter`.
- Parse STL files (consider SceneKit compatibility vs. dedicated STL parser).
- Configure SceneKit scene: camera, lights, grid, gestures.
- Implement “On Face” control with ray-cast tap to mesh and normal alignment.

### C. Bridging & Data Exchange
- Define a C wrapper API around the C++ core (e.g., `extern "C"` functions) to simplify bridging.
- Choose data hand-off strategy for the mesh (file path vs. in-memory buffer).
- Manage asynchronous slicing via `Task`/`async` APIs; ensure background thread execution.
- Map C++ status codes to Swift error types with human-readable messages.

### D. Developer Experience
- Document prerequisites (Xcode version, toolchains, dependencies).
- Provide README for Phase 1 with build/run steps and troubleshooting tips.
- Explore CI feasibility (e.g., macOS GitHub Actions runner for library builds).

## 4. Deliverables
- `ios/OrcaSlicerApp.xcodeproj` seeded for Phase 1 scope.
- `libOrcaSlicerIOS.xcframework` (or static `.a`) bundled with headers.
- Swift bridge wrapper and related protocol definitions.
- SceneKit-based viewer capable of loading and orienting STL models.
- Slice trigger returning success/failure and storing G-code locally.
- Documentation set: architecture overview, build instructions, API surface summary.

## 5. Open Questions
- Which subset of Orca Slicer features is mandatory for Phase 1 slicing (supports, materials, etc.)?
- Preferred storage or transfer strategy for produced G-code (local only vs. share/export).
- Minimum device support (iPad only vs. universal); impacts UI layout and testing scope.
- Licensing or distribution constraints when bundling Orca core into an App Store submission.
- Requirement for offline-only operation vs. future remote processing fallback.

## 6. Risks & Mitigation
| Risk | Impact | Mitigation |
| --- | --- | --- |
| Third-party libraries fail to build for iOS | High | Early spike; stub or replace problematic modules, consider feature gating |
| STL parsing or rendering performance issues | Medium | Profile with large meshes; consider simplification/LOD strategies |
| Bridging complexity (ARC vs. manual memory) | Medium | Keep C API minimal, document ownership semantics, add tests |
| App Store policy compliance (scripting, downloads) | Medium | Review guidelines early; target enterprise/TestFlight first |
| Limited familiarity with SceneKit | Low | Leverage Apple sample code; evaluate RealityKit if needed |

## 7. Forward Look: Phase 2 and Phase 3
- **Phase 2 – Slicer Settings UI:** Build dynamic UI for displaying and editing Orca Slicer configuration values.
- **Phase 3 – Printer Connectivity:** Implement Wi-Fi printer discovery, G-code upload, and job monitoring leveraging existing Orca networking code where portable.
