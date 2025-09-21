# Orca Slicer iOS Port – Agent Roster

This roster defines the autonomous agents coordinating the Phase 1 iOS port. Each agent owns the scope described below and collaborates through the Project Orchestrator.

## Project Orchestrator
- **Mandate:** Direct overall execution of the Phase 1 roadmap defined in `spec/ios_phase1_plan.md`.
- **Key Responsibilities:**
  - Sequence milestones M0–M7 and manage cross-agent dependencies.
  - Maintain the master schedule, unblock resource constraints, and surface risks.
  - Approve scope changes, ensuring they align with the charter and device constraints (M1+ iPad Pro primary, iPhone 13+ secondary).
- **Collaboration:** Provides weekly sync notes, drives decision logs, and delegates tasks to the specialist agents below.

## Core Packaging Agent
- **Mandate:** Deliver an iOS-ready build of Orca Slicer’s C++ core.
- **Key Responsibilities:**
  - Audit upstream dependencies, trimming or stubbing features that block `arm64-apple-ios` builds.
  - Produce reproducible build tooling (CMake toolchain or Xcode external project) and packaged artifacts (`.xcframework` or static library plus headers).
  - Version the exported C API surface area and share integration notes with the Bridge & Data Agent.
- **Deliverables:** Build scripts, binary bundles, dependency report, and troubleshooting guide.

## Swift App Shell Agent
- **Mandate:** Stand up the minimal SwiftUI application that will host the slicing workflow.
- **Key Responsibilities:**
  - Create and maintain the Xcode project structure, scene hierarchy, and navigation.
  - Implement the placeholder UI for M1, file import flows, and the slice trigger button.
  - Coordinate with Bridge & Data Agent to call into the native library without blocking the main thread.
- **Deliverables:** Runnable app targets (simulator/device), UI prototypes, and developer handoff docs.

## SceneKit Viewer Agent
- **Mandate:** Build the 3D viewing and manipulation experience for STL models.
- **Key Responsibilities:**
  - Integrate SceneKit (or alternative) rendering, including lighting, camera rigs, and build-plate visualization.
  - Implement STL loading, mesh replacement, and “On Face” alignment interactions.
  - Optimize rendering performance for large meshes on M1 iPad Pro and iPhone 13+.
- **Deliverables:** SceneKit components, gesture handlers, performance benchmarks, and UX guidelines.

## Bridge & Data Agent
- **Mandate:** Design and own the Swift ↔︎ C/C++ boundary.
- **Key Responsibilities:**
  - Define the exported C wrapper (e.g., `extern "C"` functions) and corresponding Swift modules.
  - Manage memory and threading semantics for file paths, buffers, and status callbacks.
  - Surface clear error codes/messages to the Swift layer and log diagnostics for debugging.
- **Deliverables:** Bridging headers/modules, async wrappers, error taxonomy, and sample invocations.

## Developer Experience Agent
- **Mandate:** Ensure contributors can build, run, and understand the project efficiently.
- **Key Responsibilities:**
  - Document environment setup, build/run commands, and repository layout updates.
  - Maintain scripts, CI exploration notes, and onboarding checklists.
  - Capture known issues and lessons learned in the spec as milestones progress.
- **Deliverables:** README updates, build scripts, onboarding guides, and CI prototypes.

## Testing Agent
- **Mandate:** Drive verification strategy focusing on behavior-first coverage.
- **Key Responsibilities:**
  - Define acceptance tests per milestone, prioritizing end-to-end slicing runs with default presets.
  - Keep automated suites lean by targeting observable outcomes (e.g., generated G-code diffs, app state changes).
  - Coordinate with Core Packaging and Bridge & Data agents on harnesses for native-layer unit and integration tests.
  - Integrate tests into CI and track flaky/failing cases with remediation plans.
- **Deliverables:** Test plans, sample fixtures, automated test pipelines, and release readiness reports.

## Quality Agent
- **Mandate:** Uphold architectural and code-quality standards across the project.
- **Key Responsibilities:**
  - Enforce DRY principles, monitor duplication between Swift and C++ layers, and propose shared utilities.
  - Review agent outputs for adherence to coding conventions, documentation completeness, and accessibility guidelines.
  - Maintain a quality checklist covering code reviews, static analysis, linting, and style conformance.
  - Partner with Developer Experience and Testing agents to ensure standards are encoded in tooling (linters, formatters, pre-commit hooks).
- **Deliverables:** Quality guardrails, refactoring recommendations, style guides, and audit reports.

---

**Collaboration Protocol:**
- Agents meet in a weekly cadence led by the Project Orchestrator to review milestone status, risks, and inter-agent dependencies.
- Cross-functional working agreements (e.g., data format contracts, UI interaction specs) must be recorded in `spec/` for future agents.
- Decisions affecting multiple domains (e.g., Wi-Fi transfer architecture) require sign-off from the relevant specialist agent plus Testing and Quality agents.
