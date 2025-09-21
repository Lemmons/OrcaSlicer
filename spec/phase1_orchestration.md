# Phase 1 Orchestration Plan

## 1. Mission Control Overview
- **Scope:** Coordinate agents to deliver the Phase 1 objectives defined in `ios_phase1_plan.md`.
- **Reporting cadence:** Weekly orchestration sync each Monday (UTC) with shared minutes; mid-week async checkpoint posted in the project channel.
- **Definition of Done (Phase 1):** Milestones M0–M7 complete with deliverables archived in `spec/` or corresponding source directories, automated checks green, and hand-off notes published.

## 2. Milestone Timeline & Ownership
| Week | Milestone(s) | Primary Lead | Key Dependencies | Exit Criteria |
| --- | --- | --- | --- | --- |
| Week 0 | M0 – Project Setup & Discovery | Core Packaging Agent | Access to current build scripts, dependency manifests | Dependency inventory produced; packaging decision recorded; Swift↔︎C++ spike summary committed |
| Week 1 | M1 – Buildable iOS Shell | Swift App Shell Agent | M0 spike output (bridge feasibility); UX outline from Quality Agent | `ios/OrcaSlicerApp` skeleton builds on simulator; navigation placeholders implemented |
| Week 2 | M2 – Orca Core Packaging | Core Packaging Agent | M0 inventory; Swift App shell target structure | Reproducible build script emits iOS-ready binary + headers; usage README drafted |
| Week 3 | M3 – Swift/C++ Bridge | Bridge & Data Agent | Packaged library from M2; Swift shell hooks | Bridge module exposes `startSlicerEngine()`; smoke test logs result inside app |
| Week 4 | M4 – 3D Viewer Foundations | SceneKit Viewer Agent | Swift shell baseline; asset pipeline decisions | SceneKit scene renders placeholder cube; STL load pipeline documented |
| Week 5 | M5 – Model Manipulation | SceneKit Viewer Agent | M4 rendering; UX validation by Quality Agent | Gesture controls for rotate/translate; "On Face" alignment demo recorded |
| Week 6 | M6 – UI → Slicer Invocation | Bridge & Data + Swift App Shell Agents | Stable bridge; slicing API contract; packaged presets from Core Packaging | Slice button triggers C++ engine; progress + status surfaced in UI |
| Week 7 | M7 – Hardening & Hand-off | Developer Experience + Testing + Quality Agents | All prior milestones; test harness inputs; documentation drafts | QA checklist complete; build/test instructions published; retrospective logged |

*Adjust timeline if blockers emerge; Orchestrator owns change control and communicates updates within 24h.*

## 3. Dependency Board
- **Toolchain readiness (M0 → M2):** Core Packaging Agent supplies compiler/toolchain matrix; Bridge & Data Agent validates symbol visibility before M3 start.
- **SceneKit data contracts (M4 → M5 → M6):** SceneKit Viewer Agent documents mesh orientation semantics; Bridge & Data Agent confirms file hand-off format; Swift App Shell Agent handles file importer integration.
- **Quality gates:** Quality Agent reviews milestone exit artifacts within two business days; Testing Agent refuses promotion without minimal acceptance tests per milestone.
- **Documentation stream:** Developer Experience Agent maintains a living `docs/ios/` index; every milestone owner must PR documentation updates alongside feature changes.

## 4. Execution Cadence & Governance
- **Weekly sync agenda:**
  1. Milestone burndown review (current/next week).
  2. Cross-agent blockers and dependency status.
  3. Risk register updates and mitigation decisions.
  4. Scope change proposals (require Orchestrator approval + impacted agent sign-off).
- **Async updates:** Each agent posts a twice-weekly status (Tue/Fri) covering progress, upcoming tasks, and help requests.
- **Decision log:** Use `spec/phase1_decisions.md` (to be created by Developer Experience Agent) with entries capturing context, decision, owner, date, and follow-up actions.
- **Escalation path:** Blockers exceeding 48h escalate to Orchestrator; unresolved risks escalate to product sponsor.

## 5. Risk & Issue Tracking
| ID | Risk | Owner | Mitigation | Trigger/Watchpoints |
| --- | --- | --- | --- | --- |
| R1 | Third-party libs fail to build for iOS | Core Packaging Agent | Identify optional components; prepare stub implementations by end of Week 0 | Missing symbols during toolchain spike |
| R2 | Bridge memory ownership bugs | Bridge & Data Agent | Define explicit allocation contracts in API spec; add unit tests before integrating into app | Crash reports or leaks in smoke test |
| R3 | SceneKit performance with large meshes | SceneKit Viewer Agent | Benchmark with >10MB STL by Week 5; propose LOD strategy if FPS <30 | FPS regression in profiling builds |
| R4 | Documentation debt slowing onboarding | Developer Experience Agent | Enforce doc update checklist per PR; audit docs during Week 7 | Missing or outdated setup instructions |
| R5 | Scope creep from slicer configuration requests | Orchestrator | Gate non-essential requests until post-Phase 1; document deferrals | New requirements raised in syncs |

## 6. Immediate Next Actions (Week 0)
- **Core Packaging Agent:** Complete dependency inventory template; evaluate static `.a` vs `.xcframework` trade-offs; publish bridge spike report.
- **Swift App Shell Agent:** Draft SwiftUI module skeleton outline; prepare questions for UX alignment.
- **Bridge & Data Agent:** Review C API surface requirements; partner on spike to confirm Swift bridging mechanics.
- **SceneKit Viewer Agent:** Research SceneKit STL loading approaches; identify sample assets for testing.
- **Developer Experience Agent:** Draft project README addendum covering Phase 1 scope; set up decision log file.
- **Testing Agent:** Outline acceptance criteria for M1 and M2; propose minimal automated checks.
- **Quality Agent:** Define code review checklist focusing on Swift/C++ integration and accessibility baseline.

## 7. Reporting & Artifacts
- **Status board:** Maintain an up-to-date Kanban (Backlog → In Progress → Review → Done) in the project tracker; Orchestrator audits weekly.
- **Documentation anchors:**
  - Architecture & decisions: `spec/`
  - Build tooling: `scripts/` + `doc/build/`
  - App layer guides: `doc/ios/`
- **Handoff package (M7):** Consolidated README, build scripts, QA checklist, and backlog of deferred items archived under `spec/phase1_handoff/`.

## 8. Change Control
- Scope adjustments require a written proposal referencing milestone impact, resource adjustments, and risk deltas.
- Orchestrator logs approved changes and communicates them during the next sync and in the shared notes.

## 9. Success Metrics
- Planned milestones achieved within ±1 week.
- Zero P0 defects open at Phase 1 closure.
- Documentation satisfaction score ≥4/5 from internal beta reviewers.
- Time-to-setup for new contributors ≤2 hours by Week 7.
