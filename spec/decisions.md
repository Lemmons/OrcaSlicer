# iOS Port Decision Log

Track key architectural and implementation decisions affecting the iOS port development.

| ID | Date | Decision | Context & Options | Owner | Impacted Agents | Status |
|----|------|----------|-------------------|-------|-----------------|--------|
| DEC-001 | 2025-09-26 | Use .xcframework for core distribution | Evaluated static .a vs .xcframework vs SwiftPM. .xcframework provides best Swift integration and future distribution path. | core-packaging, bridge-data | All | Approved |
| DEC-002 | 2025-09-26 | Target iOS 16+ with M1+ iPad Pro primary, iPhone 13+ secondary | Device constraints balance performance needs with market reach | ios-orchestrator | swift-app-shell, scenekit-viewer | Approved |
| DEC-003 | 2025-09-26 | Use SceneKit for 3D rendering | Evaluated SceneKit vs RealityKit vs Metal. SceneKit provides proven STL support and adequate performance. | scenekit-viewer | swift-app-shell | Approved |
| DEC-004 | 2025-09-26 | Additive approach - minimize upstream changes | Prefer iOS-specific additions over modifying existing OrcaSlicer core | ios-orchestrator | core-packaging, bridge-data | Approved |
| DEC-005 | 2025-09-26 | Defer OpenVDB, GMP/MPFR for Phase 1 | Large dependencies with limited Phase 1 value. Document feature loss. | core-packaging | All | Approved |

## Decision Process
1. Propose decisions affecting multiple agents via issues or PR
2. Required approval from impacted agents plus ios-quality review
3. Update this log within 24h of approval
4. Link supporting documentation where applicable