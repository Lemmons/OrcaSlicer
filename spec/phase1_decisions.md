# Phase 1 Decision Log

> **Purpose:** Track cross-team decisions that influence scope, architecture, or schedules. Each entry must reference the milestone it impacts and list required follow-ups.

| ID | Date | Decision | Context / Options Considered | Owner(s) | Impacted Milestones | Follow-up Actions | Status |
|----|------|----------|-------------------------------|----------|---------------------|-------------------|--------|
| DEC-0001 | 2025-09-21 | Target `.xcframework` as distributable for Orca core | Evaluated static `.a` (manual linking), `.xcframework`, and SwiftPM binary target. Static `.a` build blocked on Linux container; `.xcframework` best aligns with Swift integration and future SwiftPM distribution. Details captured in `spec/m0_packaging_findings.md`. | Core Packaging Agent + Bridge & Data Agent | M0, M2, M3 | Provision macOS builder; integrate `ios-cmake` toolchain; draft packaging script for simulator/device archives | Open |

> **Instructions:**
> - Keep entries concise but link to supporting documents (e.g., `spec/m0_packaging_findings.md`).
> - Update status when actions complete; closed decisions should note validation evidence.
> - Orchestrator reviews log weekly and ensures impacted agents acknowledge updates.
