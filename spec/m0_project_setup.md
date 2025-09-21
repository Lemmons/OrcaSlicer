# M0 – Project Setup & Discovery Execution Guide

## 1. Goal & Exit Criteria
- **Objective:** Validate that the existing Orca Slicer codebase and toolchain can be positioned for iOS builds without blocking downstream milestones.
- **Exit Criteria:**
  - Dependency inventory complete with iOS compatibility assessment and mitigation owners logged.
  - Packaging recommendation (static `.a` vs `.xcframework`) documented with supporting evidence and decision recorded in `spec/phase1_decisions.md`.
  - Swift↔︎C++ bridge spike demonstrating invocation of a C++ symbol from Swift on an Apple toolchain, with findings summarized and blockers captured.
  - Reporting artifacts updated: Kanban tickets, daily async posts, and checklist sign-off submitted to the Orchestrator.

## 2. Timeline (Week 0 Breakdown)
| Day | Focus | Primary Owner(s) | Expected Output |
| --- | --- | --- | --- |
| Day 1 | Kickoff, inventory scope alignment, toolchain environment check | Orchestrator + Core Packaging + Developer Experience | Meeting notes, updated Kanban cards |
| Day 2 | Dependency inventory deep dive | Core Packaging | Initial pass of inventory template with priority components |
| Day 3 | Packaging option experiments & criteria scoring | Core Packaging + Bridge & Data | Pros/cons matrix draft, build logs |
| Day 4 | Swift↔︎C++ spike implementation & validation | Bridge & Data + Swift App Shell | Minimal project compiling/running, spike notes |
| Day 5 | Consolidate findings, document risks, prepare M1 handoff inputs | Orchestrator + all agents | Finalized artifacts committed, decision log entry, M1 readiness review |

*Adjust sequencing as needed for regional holidays; any slip beyond Day 5 requires an Orchestrator-approved change request.*

## 3. Work Package Details

### 3.1 Dependency Inventory & Risk Scan
- **Owner:** Core Packaging Agent (support from Quality & Developer Experience).
- **Steps:**
  1. Parse `CMakeLists.txt`, `deps/`, and `deps_src/` to enumerate build targets and third-party libraries.
  2. Populate `spec/m0_dependency_inventory.md` (template below) capturing component details, license, platform assumptions, and iOS readiness status.
  3. Flag blockers with proposed mitigation (stub, replace, conditional compile) and assign a target resolution milestone.
  4. Share early findings with Bridge & Data Agent to anticipate bridging constraints.
- **Tools & References:**
  - `cmake --graphviz` or `cmake --trace-expand` to surface dependency graphs.
  - `rg "add_subdirectory"` / `rg "find_package"` for quick enumeration.
  - License references stored under `LICENSE.txt` and `deps_src` metadata.
- **Deliverables:** Inventory document, risk list annotated with severity, and a summary comment in the async status thread.

### 3.2 Packaging Strategy Decision
- **Owner:** Core Packaging Agent (Bridge & Data + Developer Experience consult, Quality approval).
- **Evaluation Criteria:**
  - Simulator & device compatibility (`arm64-apple-ios-simulator`, `arm64-apple-ios`).
  - Integration friction for Swift (XCFramework adoption vs. manual linking in Xcode project or Swift Package Manager).
  - Build reproducibility within CI (scriptability, deterministic artifacts).
  - Binary size & symbol visibility impacts.
  - Licensing considerations when distributing binaries.
- **Tasks:**
  1. Produce a pros/cons matrix covering at least static `.a`, `.xcframework`, and (if feasible) Swift Package Manager binary target.
  2. Run exploratory builds using the existing toolchain; capture commands, environment, and observed issues in `spec/m0_packaging_findings.md`.
  3. Summarize recommendation, include data (build duration, artifact size), and log the final decision in `spec/phase1_decisions.md` with Quality Agent sign-off.
  4. Notify Swift App Shell Agent of expected integration touchpoints (header search paths, module maps).
- **Deliverables:** Pros/cons matrix, build experiment notes, decision log entry, updated risk register if blockers persist.

### 3.3 Swift↔︎C++ Bridge Spike
- **Owner:** Bridge & Data Agent (Swift App Shell support, Quality review).
- **Spike Scope:**
  - Create a minimal C++ function (e.g., `const char* orca_version();`) compiled into a static library for iOS simulator.
  - Expose the symbol through an Objective-C++ wrapper (`extern "C"` function) and import it in a Swift target via bridging header.
  - Run on both simulator (required) and physical device if available (stretch goal) to validate code signing/toolchain steps.
- **Steps:**
  1. Stand up a temporary Xcode project (`sandbox/ios_spike/`) or Swift Package referencing the compiled library.
  2. Document compiler flags, header search paths, and any linker tweaks needed for libc++ / libstdc++ compatibility.
  3. Verify runtime call by logging to console and, if possible, surfacing a simple SwiftUI label.
  4. Record findings—including pain points, tooling versions, and open questions—in `spec/m0_bridge_spike.md`.
  5. Hand results to Core Packaging Agent to validate assumptions for M2.
- **Exit Criteria:** Spike project builds without manual Xcode UI tweaks (scriptable), bridging header pattern agreed upon, and risk notes filed if unresolved.

### 3.4 Developer Experience & Quality Hooks
- **Owner:** Developer Experience Agent (Quality consult, Orchestrator oversight).
- **Actions:**
  - Initialize `spec/phase1_decisions.md` using the template provided in this repo.
  - Draft README addendum summarizing M0 prerequisites (toolchains, dependencies, macOS version) and link to above spike documents.
  - Ensure each artifact includes metadata: owner, date, contact channel, follow-up tasks.
  - Quality Agent to craft a review checklist focusing on C++/Swift integration hygiene, licensing verification, and documentation completeness.
- **Deliverables:** Updated documentation, checklist appended to the `spec/m0_project_setup.md` appendix, and validation that async reporting cadence is established.

## 4. Roles & RACI Matrix
| Task | Core Packaging | Bridge & Data | Swift App Shell | Developer Experience | Quality | Orchestrator |
| --- | --- | --- | --- | --- | --- | --- |
| Dependency inventory | **R/A** | C | C | C | C | I |
| Packaging decision | **R/A** | R | C | C | A | I |
| Bridge spike | C | **R/A** | R | I | C | I |
| Documentation updates | C | I | I | **R/A** | C | I |
| Risk tracking & reporting | C | C | C | C | C | **R/A** |

*R = Responsible, A = Accountable, C = Consulted, I = Informed.*

## 5. Exit Checklist (Complete All Before Closing M0)
- [ ] `spec/m0_dependency_inventory.md` filled with status “Green/Yellow/Red” for each component.
- [ ] Packaging recommendation documented with acceptance from Quality Agent.
- [ ] Bridge spike log captures build commands, tool versions, and outcomes for simulator (and device if possible).
- [ ] README addendum + decision log entries merged to `main`.
- [ ] Risks escalated with mitigation owners and due dates.
- [ ] Orchestrator sign-off recorded in weekly sync notes.

## 6. Reporting Expectations
- Twice-weekly async updates (Tue/Fri) summarizing progress, blockers, and next steps.
- Sync meeting minutes stored under `spec/` with filenames `m0_sync_YYYYMMDD.md`.
- Orchestrator reviews artifacts daily and ensures blockers are recorded within 24h.

## 7. Appendices
### 7.1 Dependency Inventory Template Reference
```
| Component | Location | Type (Static/Shared/Header-only) | License | iOS Compatibility Notes | Current Status (G/Y/R) | Owner | Planned Mitigation | Target Milestone |
|-----------|----------|----------------------------------|---------|------------------------|------------------------|-------|--------------------|------------------|
```

### 7.2 Pros/Cons Matrix Template
```
| Option | Pros | Cons | Notes | Recommendation |
|--------|------|------|-------|----------------|
```

### 7.3 Spike Log Template
```
# Swift↔︎C++ Spike Log
- Date:
- Owner(s):
- Toolchain (Xcode/clang versions):
- Commands Executed:
- Outcome:
- Issues & Mitigations:
- Follow-up Tasks:
```

### 7.4 Quality Review Checklist Seeds
- Verify licenses for third-party dependencies permit static linking on iOS.
- Confirm build scripts avoid hard-coded absolute paths.
- Ensure bridge wrapper handles ownership (no raw pointers crossing boundary without contract).
- Validate documentation includes prerequisites, steps, and expected outputs.
- Capture unresolved blockers with severity and owner.
