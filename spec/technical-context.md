# iOS Port Technical Context

## Dependency Analysis Summary

Based on initial investigation, the following OrcaSlicer dependencies require attention for iOS builds:

### iOS-Ready Dependencies ✅
- **Eigen**: Header-only, no platform-specific code
- **zlib**: Portable C implementation, compiles with iOS clang
- **Boost (selected)**: Mostly header-only, filesystem module needs iOS validation

### Requires iOS Configuration 🔧
- **cURL**: Build with Secure Transport (`-DCURL_USE_SECTRANSP=ON`) instead of OpenSSL
- **OpenSSL**: Use upstream iOS build scripts (`./Configure ios64-simulator`, `ios64-cross`)
- **CGAL**: Configure header-only mode (`CGAL_HEADER_ONLY=ON`), avoid Qt/OpenGL hooks
- **libslic3r**: Main target needs iOS toolchain, stub wxWidgets dependencies

### Problematic for Phase 1 ❌
- **oneTBB**: No upstream iOS support, consider libdispatch replacement
- **OpenVDB**: Heavy dependency chain, limited FDM value
- **GMP/MPFR**: Assembly issues on arm64-ios, affects STEP import
- **wxWidgets**: Desktop-only, must exclude from iOS builds

## Build Strategy

### Core Library Packaging
```bash
# Target: libOrcaSlicerIOS.xcframework
# Include: Core slicing engine, file I/O, geometry processing
# Exclude: GUI components, problematic dependencies
```

### Swift Integration Approach
- **C API Wrapper**: Extern "C" functions wrapping C++ core
- **Swift Module**: Async wrappers for non-blocking operation
- **Memory Management**: Clear ownership semantics, ARC-compatible
- **Error Handling**: Structured error codes with Swift Error conformance

## Performance Considerations

### Target Devices
- **Primary**: M1+ iPad Pro (8GB+ RAM, high-performance cores)
- **Secondary**: iPhone 13+ (6GB+ RAM, adequate for basic slicing)

### 3D Rendering
- **Large Meshes**: Profile >10MB STL files, implement LOD if needed
- **SceneKit**: Metal-backed, hardware-accelerated rendering
- **Memory**: Monitor mesh data retention, implement cleanup strategies

## M0 Discovery Summary

### Packaging Experiments
- **Static .a builds**: Failed on Linux container due to missing Apple SDK
- **.xcframework approach**: Preferred for Swift integration, requires macOS host
- **SwiftPM distribution**: Deferred until .xcframework pipeline validated

### Bridge Spike Findings
- **Entry Point Strategy**: Use POD-friendly APIs (const char*) to avoid ABI issues
- **Memory Management**: Copy semantics for C++ → Swift string conversion
- **Build Requirements**: Requires Xcode CLI tools, ios-cmake toolchain
- **Verification**: Pending macOS host availability for iOS SDK access

### Key M0 Decisions
- Target .xcframework as primary distribution format
- Require macOS build host for iOS toolchain
- Use extern "C" wrapper with minimal surface area
- Defer SwiftPM packaging until Phase 2

## Agent Development Context

### core-packaging Agent
- Focus on CMake iOS toolchain configuration
- Investigate community patches for problematic dependencies
- Document feature tradeoffs for excluded components

### bridge-data Agent
- Design minimal C API surface for Phase 1 scope
- Handle async operations to avoid blocking main thread
- Plan memory ownership contracts carefully

### scenekit-viewer Agent
- Leverage Apple sample code for SceneKit integration
- Benchmark rendering performance early and often
- Consider mesh optimization strategies for large models

### swift-app-shell Agent
- Use SwiftUI with NavigationStack for iOS 16+ features
- Implement proper document picker integration
- Plan for proper background processing during slicing

## Known Limitations

- **STEP Import**: Deferred due to GMP/MPFR complexity
- **Volumetric Features**: OpenVDB excluded, affects some advanced features
- **Multi-threading**: May need iOS-specific threading patterns
- **File System**: iOS sandbox restrictions affect file access patterns

## Future Considerations

- **Phase 2**: Dynamic slicer configuration UI
- **Phase 3**: Printer connectivity and G-code transfer
- **Performance**: Consider Metal compute shaders for expensive operations
- **Distribution**: App Store vs enterprise deployment considerations