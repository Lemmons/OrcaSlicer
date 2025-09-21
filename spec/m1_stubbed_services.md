# M1 Template – Stubbed Services & Bridge Contracts

Document the placeholder services introduced in M1 to simulate future integrations. Use this template to ensure the Swift ↔︎ C++ boundary is ready for replacement in later milestones.

## 1. Service Inventory
| Service Name | Purpose | Owner | Implementation Location | Downstream Replacement (Milestone) | Swap Strategy |
| ------------ | ------- | ----- | ----------------------- | ---------------------------------- | ------------- |
| `MockSlicingService` |  |  |  |  |  |
| `MockModelRepository` |  |  |  |  |  |
| `MockUserPreferences` |  |  |  |  |  |
| _(add rows as needed)_ |  |  |  |  |  |

## 2. API Surface (per Service)
### Example: `MockSlicingService`
- **Protocol / Interface Definition:**
- **Swift Implementation Summary:**
- **Inputs:** _(file URL, config struct, callbacks)_
- **Outputs:** _(success/failure enum, progress updates)_
- **Threading Expectations:**
- **Error Handling Strategy:**
- **Metrics / Logging Hooks:**

_(Repeat subsection for each service.)_

## 3. Data Contracts & Models
| Model | Definition Location | Fields & Types | Ownership / Memory Notes | Ready for Bridge? (Y/N) | Follow-ups |
| ----- | ------------------- | -------------- | ------------------------ | ----------------------- | ---------- |
| `SliceJobRequest` |  |  |  |  |  |
| `SliceJobResult` |  |  |  |  |  |
| `ModelMetadata` |  |  |  |  |  |

## 4. Integration Points
- **Future Bridge Entry Points:**
  - Name:
  - Expected Signature:
  - Notes:
- **Dependencies on Core Packaging Artifacts:**
- **Testing Hooks / Injected Dependencies:**

## 5. Risks & Mitigations
| Risk | Impact | Owner | Mitigation Plan | Target Review |
| ---- | ------ | ----- | --------------- | ------------- |
|  |  |  |  |  |
|  |  |  |  |  |

_Last updated:_
