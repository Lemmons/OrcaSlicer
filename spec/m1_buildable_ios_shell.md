# M1 – Buildable iOS Shell Execution Guide

## 1. Goal & Exit Criteria
- **Objective:** Deliver a SwiftUI-based iOS shell that compiles and runs on simulator and device targets, establishing the directory structure, build scripts, and placeholder UI for later milestones.
- **Exit Criteria:**
  - Xcode project (or Swift Package) checked in under `ios/` with schemes for simulator and device, building without manual configuration.
  - SwiftUI navigation scaffold present with placeholder screens for model browser, viewer, and slicing controls mapped to view models.
  - File import stub implemented (using `FileImporter` or similar) persisting selected STL path for downstream milestones.
  - App launch, navigation flow, and mock slice trigger verified via build validation log with screenshots or console output.
  - Updated documentation: repo layout rationale, build/run steps for macOS contributors, and the populated templates defined in Appendix 7.

## 2. Timeline (Week 1 Breakdown)
| Day | Focus | Primary Owner(s) | Expected Output |
| --- | --- | --- | --- |
| Day 1 | Confirm requirements, align on architecture patterns, and fork repo structure | Orchestrator + Swift App Shell + Developer Experience | Kickoff notes, initial backlog, directory layout proposal |
| Day 2 | Generate Xcode project / Swift package, configure targets & bundle identifiers | Swift App Shell (Quality consult) | `ios/OrcaSlicerApp.xcodeproj`, schemes created, signing strategy notes |
| Day 3 | Implement SwiftUI navigation skeleton & state containers | Swift App Shell | Views scaffolded, view model protocols drafted, UI preview screenshots |
| Day 4 | Add file import stub, mock slicer service, and persistence hooks | Swift App Shell + Bridge & Data | File importer working in simulator, stub service returning canned result |
| Day 5 | Harden build scripts, document instructions, capture validation evidence | Developer Experience + Quality + Orchestrator | Build validation log completed, README updates merged, exit checklist review |

*Shifts longer than one day must be escalated to the Orchestrator. Coordinate asynchronously for shared workstreams to avoid blocking.*

## 3. Work Package Details

### 3.1 Repository Layout & Build System
- **Owner:** Swift App Shell Agent (Developer Experience consulted, Quality informed).
- **Steps:**
  1. Propose `ios/` directory layout: app target, shared resources, bridging headers, package manifests.
  2. Capture structure within `spec/m1_app_structure.md`, including module boundaries and rationale.
  3. Create Xcode project via `xcodebuild -project` compatible scripting or SPM package; ensure reproducible by adding generation script if using `xcodegen`.
  4. Configure signing profiles for team-less debug builds (automatic signing or development team placeholder) and document requirements.
  5. Verify builds on both `arm64-apple-ios` (device) and `arm64-apple-ios-simulator`; note any gating issues in the validation log.
- **Deliverables:** Project file committed, structure template filled, build script or documented regeneration process, signing guidance.

### 3.2 SwiftUI Shell & Navigation Framework
- **Owner:** Swift App Shell Agent (Quality accountable for review).
- **Steps:**
  1. Define navigation flow (e.g., `AppEntryView -> ModelLibraryView -> ModelViewerView`), referencing `spec/m1_ui_screens.md`.
  2. Implement placeholder views with state containers using MVVM or Composable Architecture (decision recorded in `spec/phase1_decisions.md`).
  3. Include preview providers or unit snapshots for each view to accelerate QA.
  4. Wire up toolbar buttons and gestures to stubbed actions (no real slicing yet) to validate event flow.
  5. Ensure accessibility labels exist on primary UI elements and note coverage in the UI template.
- **Deliverables:** SwiftUI source files, updated UI template, preview screenshots logged.

### 3.3 File Import & Model Context Management
- **Owner:** Swift App Shell Agent (Bridge & Data consulted).
- **Steps:**
  1. Choose file import mechanism (`FileImporter`, `UIDocumentPicker`) and record reasoning in `spec/phase1_decisions.md`.
  2. Implement asynchronous importer capturing URL security-scoped bookmarks when required; store results in view model with placeholder metadata.
  3. Update `spec/m1_stubbed_services.md` with contract for the mock `SlicingService` and data structures shared across milestones.
  4. Provide sample STL asset for development (optional) and document location.
  5. Ensure error handling paths display alerts or inline messaging and log coverage.
- **Deliverables:** Importer code, stub service documentation, updated decision log entry, validation entry demonstrating importer workflow.

### 3.4 Bridge Preparation & Dependency Contracts
- **Owner:** Bridge & Data Agent (Swift App Shell consulted, Core Packaging informed).
- **Steps:**
  1. Define placeholder protocol or service interface that the future M3 bridge will conform to; document in stub services template.
  2. Identify data contract: file path vs. data blob, config struct placeholder. Capture open questions.
  3. Collaborate with Core Packaging Agent to ensure build settings align with expected binary formats (static library vs. XCFramework) and record compatibility notes.
  4. Insert compile-time flags or dependency injection to swap stub with real bridge later without refactoring navigation layer.
- **Deliverables:** Interface definitions, compatibility notes appended to `spec/m1_stubbed_services.md`, action items for M2/M3.

### 3.5 Developer Experience & Quality Gates
- **Owner:** Developer Experience Agent (Quality accountable, Orchestrator informed).
- **Steps:**
  1. Update README or create `doc/ios_setup.md` with prerequisites, build commands, simulator/device run steps.
  2. Fill `spec/m1_build_validation.md` with each build/test run, capturing command, outcome, screenshots/log references.
  3. Establish linting/formatting baseline (SwiftFormat/SwiftLint) and document configuration for later automation.
  4. Coordinate with Quality Agent on review checklist (accessibility, localization placeholders, state management hygiene) and append to this guide if necessary.
  5. Ensure CI feasibility noted (macOS runners, caching) with action items for M2.
- **Deliverables:** Updated documentation, validation log, tooling plan, quality checklist updates.

## 4. RACI Matrix
| Task | Swift App Shell | Bridge & Data | Core Packaging | Developer Experience | Quality | Orchestrator |
| --- | --- | --- | --- | --- | --- | --- |
| Repository layout & project creation | **R/A** | I | C | C | C | I |
| SwiftUI navigation & placeholder UI | **R** | C | I | I | **A** | I |
| File import stub & context management | **R** | C | I | I | A | I |
| Bridge contract definition | C | **R/A** | C | I | C | I |
| Documentation & validation log | C | I | I | **R/A** | C | I |
| Risk tracking & milestone reporting | C | C | C | C | C | **R/A** |

*R = Responsible, A = Accountable, C = Consulted, I = Informed.*

## 5. Exit Checklist (Complete Before Closing M1)
- [ ] `ios/` project builds on simulator & device without manual project edits after checkout.
- [ ] `spec/m1_app_structure.md` populated with final directory layout and module responsibilities.
- [ ] `spec/m1_ui_screens.md` updated with each screen’s status, accessibility notes, and preview references.
- [ ] `spec/m1_stubbed_services.md` documents mock slicing contract and integration points for real bridge.
- [ ] `spec/m1_build_validation.md` records at least two successful build runs and one failure scenario with mitigation.
- [ ] README / setup docs updated; PR reviewed by Quality and Orchestrator sign-off captured in sync notes.
- [ ] All open risks logged with owners and mitigation milestones.

## 6. Reporting Expectations
- Async updates three times per week (Mon/Wed/Fri) summarizing progress, blockers, and next actions.
- Weekly sync chaired by Orchestrator; minutes stored as `spec/m1_sync_YYYYMMDD.md`.
- Immediate escalation to Orchestrator if build breaks for >4 working hours or signing issues block contributors.

## 7. Appendices & Templates
- **Template A:** `spec/m1_app_structure.md` – capture module layout, ownership, and dependency notes.
- **Template B:** `spec/m1_ui_screens.md` – track screen implementation status, preview references, and accessibility coverage.
- **Template C:** `spec/m1_stubbed_services.md` – document mock services, API contracts, and swap strategy for real bridge.
- **Template D:** `spec/m1_build_validation.md` – log build/run attempts, outcomes, and evidence links.

*Complete templates as part of milestone delivery; update decision log with any deviations from this guide.*
