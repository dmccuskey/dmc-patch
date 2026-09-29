# Changelog

## 0.2.0 (2026-09-29)

### Changed

- The patches are now lua-patch 0.4.0's, from DMC-Lua-Library's `lib.dmc_lua.lua_patch`: `require 'dmc_corona.dmc_patch'` returns a copy of it, so the shared module is left as it is. From lua-patch 0.4.0:
  - `removeAllPatches()` works (it was `nil`), and turns all three patches off.
  - `removePatch()` with no argument turns `print-output` off too.
  - An unknown patch name is named in the error (it said `'nil'`).
  - `fmt % { ... }` passes on the values after a `nil` in the array.
  - `__version` in the module.
- Rebuilt with dmc-corona-boot 1.6.0 and the current DMC-Lua-Library.

### Added

- `VERSION` in the table the module returns.
- Unit tests: `tests/run_unit.sh`, plain Lua 5.1.

### Removed

- The copy of `Utils.extend()`, which set the global `_extend`; the module uses DMC-Lua-Library's `lua_utils`.

## 0.1.0

- First release: lua-patch 0.3.0 packaged for Solar2D.
