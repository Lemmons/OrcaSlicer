# OrcaSlicer iOS Port - Phase 1 Development Plan

## Overview

This plan coordinates the Phase 1 iOS port of OrcaSlicer using Claude's specialized agent architecture. Each agent has clearly defined responsibilities and works collaboratively to deliver a functional iOS slicer app.

### Core Objective
Deliver a Phase 1 iOS app that can view 3D models, reorient them, and invoke OrcaSlicer's engine via a Swift↔︎C++ bridge, enabling "slice on device" with default settings.

### Success Criteria
- Xcode project builds and runs on ARM64 simulator and device targets
- OrcaSlicer core compiles into iOS-ready library responding to Swift bridge calls
- Users can load STL, orient on virtual build plate, trigger slicing with defaults
- Minimal changes to upstream OrcaSlicer codebase (additive approach preferred)

## Agent Responsibilities & Milestones

### ios-orchestrator
**Mandate:** Direct Phase 1 roadmap execution and coordinate cross-agent dependencies

**Key Responsibilities:**
- Sequence milestones M0-M7 and manage dependencies
- Maintain master schedule, unblock constraints, surface risks
- Approve scope changes aligned with charter and device constraints
- Weekly sync coordination and decision logging

**Deliverables:** Project coordination, risk management, milestone sequencing

### core-packaging
**Mandate:** Package OrcaSlicer C++ core for iOS arm64-apple-ios target

**Key Responsibilities:**
- Audit upstream dependencies, trim/stub iOS-incompatible features
- Produce reproducible build tooling (CMake toolchain/Xcode external project)
- Package artifacts (.xcframework or static library + headers)
- Version C API surface and provide integration documentation

**Milestones:**
- **M0:** Dependency inventory and packaging spike (Week 0)
- **M2:** Reproducible iOS build system producing packaged library (Week 2)

**Deliverables:** Build scripts, binary bundles, dependency audit, integration guide

### swift-app-shell
**Mandate:** Build SwiftUI application shell hosting slicing workflow

**Key Responsibilities:**
- Create/maintain Xcode project structure and navigation
- Implement placeholder UI for file import and slice trigger
- Coordinate with bridge-data agent for native library integration
- Ensure responsive UI that doesn't block main thread

**Milestones:**
- **M1:** Buildable iOS shell with navigation scaffold (Week 1)
- **M6:** Complete UI → Slicer invocation flow (Week 6)

**Deliverables:** Runnable app targets, UI prototypes, navigation framework

### scenekit-viewer
**Mandate:** Build 3D STL viewing and manipulation using SceneKit

**Key Responsibilities:**
- Integrate SceneKit rendering with lighting, cameras, build-plate visualization
- Implement STL loading, mesh replacement, "On Face" alignment
- Optimize rendering performance for large meshes on target devices
- Provide gesture controls for rotation/translation

**Milestones:**
- **M4:** 3D viewer foundations with SceneKit integration (Week 4)
- **M5:** Model manipulation and "On Face" alignment (Week 5)

**Deliverables:** SceneKit components, gesture handlers, performance benchmarks

### bridge-data
**Mandate:** Design Swift↔︎C++ boundary layer for core integration

**Key Responsibilities:**
- Define exported C wrapper (extern "C" functions) and Swift modules
- Manage memory/threading semantics for file paths, buffers, callbacks
- Surface clear error codes/messages and diagnostic logging
- Async wrapper design for non-blocking operation

**Milestones:**
- **M3:** Swift/C++ bridge with smoke test integration (Week 3)
- **M6:** Complete bridge integration for slicing workflow (Week 6)

**Deliverables:** Bridging headers/modules, async wrappers, error handling

### ios-testing
**Mandate:** Drive iOS-specific verification focusing on end-to-end workflows

**Key Responsibilities:**
- Define acceptance tests per milestone prioritizing slicing runs
- Keep automated suites lean targeting observable outcomes
- Coordinate with core-packaging and bridge-data on native test harnesses
- Integrate tests into CI and track remediation

**Milestones:**
- **M7:** Complete test strategy and automated pipeline (Week 7)

**Deliverables:** Test plans, fixtures, automated pipelines, release readiness

### ios-quality
**Mandate:** Uphold architectural standards across Swift/C++ boundaries

**Key Responsibilities:**
- Enforce DRY principles, monitor duplication between layers
- Review outputs for coding conventions, documentation, accessibility
- Maintain quality checklist covering reviews, analysis, linting
- Partner with ios-developer-experience on tooling standards

**Continuous:** Quality gates throughout all milestones

**Deliverables:** Quality guardrails, refactoring recommendations, style guides

### ios-developer-experience
**Mandate:** Maintain iOS-specific tooling, documentation, and onboarding

**Key Responsibilities:**
- Document environment setup, build/run commands, repository updates
- Maintain scripts, CI exploration, onboarding checklists
- Capture known issues and lessons learned throughout milestones
- Ensure contributor productivity and smooth handoffs

**Continuous:** Documentation and tooling throughout project

**Deliverables:** README updates, build scripts, onboarding guides, CI prototypes

## Milestone Timeline

| Week | Milestone | Primary Agents | Key Dependencies | Exit Criteria |
|------|-----------|----------------|------------------|---------------|
| Week 0 | **M0** - Project Setup & Discovery | core-packaging, bridge-data | Build system access, dependency manifests | Dependency inventory complete, packaging decision recorded, Swift↔︎C++ spike validated |
| Week 1 | **M1** - Buildable iOS Shell | swift-app-shell, ios-developer-experience | M0 spike output, UX guidelines | `ios/OrcaSlicerApp` builds on simulator, navigation placeholders functional |
| Week 2 | **M2** - Core Packaging | core-packaging | M0 inventory, Swift app structure | Reproducible build script produces iOS binary + headers, usage docs complete |
| Week 3 | **M3** - Swift/C++ Bridge | bridge-data | M2 packaged library, Swift shell hooks | Bridge exposes core functions, smoke test validates integration |
| Week 4 | **M4** - 3D Viewer Foundations | scenekit-viewer | Swift baseline, asset pipeline | SceneKit renders models, STL loading pipeline documented |
| Week 5 | **M5** - Model Manipulation | scenekit-viewer | M4 rendering, UX validation | Gesture controls working, "On Face" alignment demonstrated |
| Week 6 | **M6** - UI → Slicer Integration | swift-app-shell, bridge-data | Stable bridge, slicing API, packaged presets | Slice button triggers engine, progress/status visible in UI |
| Week 7 | **M7** - Hardening & Handoff | ios-testing, ios-quality, ios-developer-experience | All prior milestones | QA checklist complete, docs published, retrospective captured |

## Technical Architecture

### Build System
- **Target:** iOS 16+ on arm64-apple-ios (primary: M1+ iPad Pro, secondary: iPhone 13+)
- **Core Library:** Static library or .xcframework with C API wrapper
- **App Framework:** SwiftUI with SceneKit for 3D rendering
- **Bridge Strategy:** C wrapper functions with Swift async integration

### Key Dependencies (iOS-Compatible Subset)
- **Required:** Eigen (header-only), zlib, Boost (selected modules)
- **Conditional:** cURL (Secure Transport), OpenSSL (iOS builds)
- **Excluded/Deferred:** OpenVDB (Phase 1), GMP/MPFR (STEP support), wxWidgets

### Data Flow
1. **Import:** Swift FileImporter → STL file path
2. **Display:** SceneKit scene with loaded mesh
3. **Manipulation:** Gesture controls update model transform
4. **Processing:** Bridge passes model + config to C++ core
5. **Output:** Generated G-code returned via async callback

## Risk Management

| Risk | Impact | Owner | Mitigation |
|------|--------|-------|------------|
| Third-party libs fail iOS builds | High | core-packaging | Early spike, stub problematic modules, feature gating |
| Bridge memory ownership complexity | Medium | bridge-data | Minimal C API, explicit contracts, comprehensive tests |
| SceneKit performance with large meshes | Medium | scenekit-viewer | Profile >10MB STL, implement LOD if FPS <30 |
| Documentation debt slowing onboarding | Low | ios-developer-experience | Enforce doc updates per PR, audit in M7 |
| Scope creep from config requests | Medium | ios-orchestrator | Gate non-essentials until post-Phase 1 |

## Working Protocols

### Agent Coordination
- **Weekly Sync:** Monday UTC with shared minutes
- **Async Updates:** Tuesday/Friday status posts covering progress, blockers, help requests
- **Decision Log:** Maintain `spec/decisions.md` with context, decision, owner, date
- **Escalation:** 48h blocker limit before orchestrator involvement

### Quality Gates
- ios-quality reviews milestone artifacts within 2 business days
- ios-testing validates acceptance criteria before milestone closure
- All agents update documentation alongside feature changes
- Cross-agent contracts (data formats, APIs) recorded in `spec/`

### Success Metrics
- Milestones achieved within ±1 week
- Zero P0 defects at Phase 1 closure
- Documentation satisfaction ≥4/5 from reviewers
- New contributor setup time ≤2 hours by Week 7

## Phase 1 Deliverables

- **Application:** `ios/OrcaSlicerApp.xcodeproj` with functional slicing workflow
- **Core Library:** `libOrcaSlicerIOS.xcframework` with headers and integration docs
- **Bridge Layer:** Swift wrapper modules with async/error handling
- **3D Viewer:** SceneKit-based STL viewer with manipulation controls
- **Documentation:** Architecture overview, build instructions, API reference
- **Testing:** Automated test suite with CI integration plan

## Future Phases Preview

- **Phase 2:** Slicer settings UI with dynamic configuration management
- **Phase 3:** Printer connectivity via Wi-Fi discovery and G-code upload

---

*This plan aligns the iOS port development with Claude's agent architecture, ensuring clear ownership, efficient coordination, and systematic progress toward a functional iOS slicer application.*