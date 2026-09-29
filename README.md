# dmc-patch

Add a few Python-style conveniences to Lua in Solar2D (formerly Corona SDK): `%` for string formatting, `table.pop()`, and `pnotice()`/`pwarn()` for marked-up log lines.

dmc-patch is [lua-patch](https://github.com/dmccuskey/lua-patch) packaged like the other DMC Solar2D libraries. Each patch is turned on (and off) by name, and changes Lua's global environment, not a single module: after `addPatch( 'string-format' )`, every string in the app has the `%` operator:

```lua
local Patch = require 'dmc_corona.dmc_patch'
Patch.addPatch( 'string-format' )

print( "http://%s:%d/" % { 'server.com', 9034 } )  --> http://server.com:9034/
```

## Features

- `string-format`: `fmt % value` or `fmt % { values }` is `string.format()`, as in Python
- `table-pop`: `table.pop( t, key )` returns a value and removes it from the table
- `print-output`: global `pnotice()` and `pwarn()` print a message marked `[NOTICE]` or `[WARNING]`
- Turn patches on and off by name, one at a time or all at once
- The same module the DMC network libraries turn their patches on with (dmc-websockets, dmc-wamp, dmc-netstream)
- Pure Lua, no plugins needed; MIT licensed

## Quick Start

The following code will get you up and running in about 10 minutes in the Solar2D Simulator on macOS or Windows. It turns on the patches and uses each of them.

Prerequisites: the [Solar2D](https://solar2d.com/) Simulator and a copy of this repository (`git clone https://github.com/dmccuskey/dmc-patch.git`, or download the ZIP from GitHub).

### 1. Copy the Library into Your Project

Copy these from this repository into the root of your project folder:

```text
dmc_corona_boot.lua     loader for the DMC libraries
dmc_corona.cfg          configuration
dmc_corona/             dmc-patch and the modules it needs
```

**Going further:** keep the libraries in a subfolder, or combine several DMC libraries ([dmc-corona-boot Configuration](https://github.com/dmccuskey/dmc-corona-boot/blob/master/docs/configuration.md)).

### 2. Use the Patches

Create `main.lua` in the project folder:

```lua
local Patch = require 'dmc_corona.dmc_patch'

Patch.addAllPatches()

print( "we rode %s %s horses" % { 4, 'big' } )
print( "http://%s:%d/" % { 'server.com', 9034 } )

local pending = { id_12='one', id_45='two' }
print( table.pop( pending, 'id_12' ), pending.id_12 )

pwarn( "disk almost full", { newline=false } )

Patch.removePatch( 'string-format' )
```

Open the project in the Simulator. The screen stays black; the console shows:

```text
Lua Patch::activating patch 'table-pop'
Lua Patch::activating patch 'string-format'
we rode 4 big horses
http://server.com:9034/
one	nil
[WARNING] disk almost full
Lua Patch::deactivating patch 'string-format'
```

If the console shows `module 'dmc_corona.dmc_patch' not found` instead, `dmc_corona/` is missing from the root of the project folder.

`addAllPatches()` turns on all three patches; the module prints a line each time it turns `string-format` or `table-pop` on or off. `removePatch( 'string-format' )` turns it off again, for the whole app: turn off only a patch that nothing else in the app uses (see [Known Issues](#known-issues)).

**Going further:** each patch in detail, and turning on a single one ([Reference](https://github.com/dmccuskey/lua-patch#reference)).

To update, copy `dmc_corona_boot.lua` and `dmc_corona/` again from the newer version. Keep your own `dmc_corona.cfg` if you have changed it.

## Documentation

`require 'dmc_corona.dmc_patch'` returns a copy of lua-patch's module (0.4.0) with `VERSION` added, so its documentation applies as written:

- [Reference](https://github.com/dmccuskey/lua-patch#reference): `addPatch()`, `removePatch()`, `removeAllPatches()`, and each patch
- [Known Issues](https://github.com/dmccuskey/lua-patch#known-issues) of the patches

## Configuration

dmc-patch has no settings: `dmc_corona.cfg` needs no `[DMC_PATCH]` section, only the `[DMC_CORONA]` section that tells the loader where the libraries are. See [dmc-corona-boot Configuration](https://github.com/dmccuskey/dmc-corona-boot/blob/master/docs/configuration.md).

## Known Issues

dmc-patch's own code has none known. The patches' are in lua-patch's [Known Issues](https://github.com/dmccuskey/lua-patch#known-issues); the one to know first: patches are global, and nothing counts who uses them, so `removePatch()` and `removeAllPatches()` also turn a patch off for the DMC libraries that turned it on and still need it (dmc-websockets turns on all three, dmc-wamp `table-pop` and `print-output`, dmc-netstream `string-format`).

## Development

Only `dmc_corona/dmc_patch.lua` and `tests/` are written in this repository. `dmc_patch.lua` loads the DMC boot loader and returns a copy of lua-patch's module from `lib.dmc_lua.lua_patch`, with `VERSION`; the shared module is left as it is (the patches themselves are global either way). Everything else is a generated copy; fix it in its own repository, then rebuild:

| file | owner |
|---|---|
| every file in `dmc_corona/lib/dmc_lua/` | [DMC-Lua-Library](https://github.com/dmccuskey/DMC-Lua-Library), which copies them from the `lua-*` repositories ([lua-patch](https://github.com/dmccuskey/lua-patch), ...) |
| `dmc_corona_boot.lua` | [dmc-corona-boot](https://github.com/dmccuskey/dmc-corona-boot) |

The copies are made by Snakemake from sibling checkouts of the repositories above (`../DMC-Lua-Library`, `../dmc-corona-boot`, `../DMC-Corona-Library` for the shared rules). From this repository's root folder:

```sh
snakemake --cores 1 build_all
```

The build copies all of DMC-Lua-Library, not only lua-patch.

The unit tests check the wrapper and that lua-patch's fixes come through it; lua-patch's full specs are in its `spec/`. They run under plain Lua 5.1 with dkjson, with stand-ins for the Solar2D globals the boot loader uses. From the repository's root folder:

```sh
tests/run_unit.sh
```

The patches' on/off lines are mixed with the test output. The Quick Start is the check that the package loads in Solar2D.

## License

dmc-patch is released under the [MIT License](LICENSE).
