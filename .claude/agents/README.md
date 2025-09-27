# OrcaSlicer iOS Port - Agent Configuration

This directory contains specialized Claude Code agents for the OrcaSlicer iOS port project, based on the roadmap defined in `spec/ios_phase1_plan.md` and agent roster in `spec/AGENTS.md`.

## Agent Roster

### Strategic Coordination (Model: Opus)

- **`ios-orchestrator.md`** - Project Orchestrator for Phase 1 iOS port roadmap (M0-M7)
- **`ios-quality.md`** - Quality assurance across Swift/C++ boundaries and iOS standards

### Development Specialists (Model: Sonnet)

- **`core-packaging.md`** - C++ core packaging for iOS arm64 targets
- **`swift-app-shell.md`** - SwiftUI application development for iPad/iPhone
- **`scenekit-viewer.md`** - 3D model viewing and manipulation with SceneKit
- **`bridge-data.md`** - Swift ↔ C++ integration and data flow management
- **`ios-developer-experience.md`** - iOS-specific tooling and documentation
- **`ios-testing.md`** - iOS verification strategy and device testing

## Project Context

### Target Platforms
- **Primary**: M1+ iPad Pro (12.9" and 11")
- **Secondary**: iPhone 13+
- **Architecture**: arm64-apple-ios

### Technology Stack
- **Core**: C++ (existing OrcaSlicer libslic3r)
- **UI**: SwiftUI with iOS platform integration
- **3D Rendering**: SceneKit for model visualization
- **Integration**: C API bridge layer for Swift/C++ communication

### Phase 1 Milestones (M0-M7)
Agents coordinate around the milestone progression defined in `spec/ios_phase1_plan.md`, from initial buildable shell (M0) through functional slicing workflow (M7).

## Usage Examples

### Invoke Project Orchestrator
```
/agent ios-orchestrator
Review current milestone progress and identify blockers for M3 completion
```

### Invoke Core Packaging Agent
```
/agent core-packaging
Audit dependencies in deps/ directory for iOS arm64 compatibility and create build plan
```

### Invoke Swift App Shell Agent
```
/agent swift-app-shell
Implement file picker integration for STL model import on iPad Pro
```

## Collaboration Protocol

- **Weekly Sync**: Led by iOS Orchestrator to review milestone status and dependencies
- **Cross-functional Decisions**: Require sign-off from relevant specialist + Testing + Quality agents
- **Documentation**: All working agreements recorded in `spec/` directory
- **Escalation**: Multi-domain decisions (architecture, performance) go through iOS Orchestrator

## Quality Standards

All agents follow established patterns:
- iOS platform best practices and Human Interface Guidelines
- Memory management appropriate for iOS constraints
- Performance targeting M1 iPad Pro and iPhone 13+
- Accessibility compliance for iOS assistive technologies
- Integration with existing OrcaSlicer C++ codebase patterns