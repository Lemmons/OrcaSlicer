# M0 Dependency Inventory

> **Instructions:** Catalog every library, module, and external asset required to build the Orca Slicer core for iOS. Update the status column as progress is made. Use “Green” when confirmed iOS-ready, “Yellow” when investigation is ongoing, and “Red” when a blocker exists. Link detailed notes or tickets where applicable.

| Component | Location / Target | Type (Static/Shared/Header-only) | License | iOS Compatibility Notes | Current Status (G/Y/R) | Owner | Planned Mitigation | Target Milestone |
|-----------|-------------------|----------------------------------|---------|------------------------|------------------------|-------|--------------------|------------------|
| _Example: libcurl_ | `deps/libcurl` | Shared | MIT | Requires Secure Transport build; investigate `ENABLE_IPV6` flags | Yellow | Core Packaging | Evaluate using Apple CFNetwork API or build with custom toolchain | M2 |

- **Last Updated:** _(fill in)_
- **Reference Commands:**
  - `rg "find_package" -g"CMakeLists.txt"`
  - `cmake --graphviz=deps.dot` (visualize target relationships)

> **Reminder:** Record any licensing red flags separately for Quality Agent review.
