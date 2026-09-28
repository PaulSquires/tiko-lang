# std

The tiko standard package: modules shipped with the compiler, imported as
`#import "std/strings"`. `std` always resolves here, never to a project's own package of
that name (RFC-0007 §3, §5).

## The modules

Each module is a **facade** over a header library in the toolchain's `inc/` (RFC-0009). It
includes the header and re-exports the header's `FB.*` names under the module's alias:
`fs.PathJoin` is `FB.PathJoin`. The headers remain the one copy of the code, and fbc-modern
builds tiko-lang from them.

| Module | Fronts | Needs |
|---|---|---|
| `std/strings` | `fb/string.bi`, plus its own generic `Surround` | |
| `std/fs` | `fb/filesystem.bi`: paths, directories, files, globs, links, volumes, and `std/path`'s old names | |
| `std/containers` | `containers.bi`: `Array`, `Map`, `Set`, `LinkedList`, `OrderedMap`, `OrderedSet`, `Sort` | |
| `std/chrono` | `fb/chrono.bi`: `DateTime`, `LocalDate`, `TimeSpan`, `Stopwatch`, `WallClock` … | |
| `std/tasks` | `fb/scheduler.bi`, `channel.bi`, `sync.bi`: `Channel`, `WaitGroup`, `Context` … | `-mt` |
| `std/maybe` | `fb/optional.bi`, `fb/result.bi`: `Optional`, `Result`, `Some`, `None`, `Ok`, `Fail` | |
| `std/numeric` | `fb/math.bi`, `mathint`, `complex`, `mathtext`, `random`, `stats`, `fenv`, `vector` | |
| `std/money` | `fb/decimal.bi`, `currency`, `moneyformat`, `finance` | |
| `std/logs` | `fb/logging.bi` | |
| `std/tui` | `fb/tui.bi` | |

**What a facade's names are:**
- **Qualified only.** The names are exported macros, so they are reached as `alias.NAME`.
  `using strings` does not make `Replace` a name. For bare names, write `using FB`: the
  header travels with the module's interface, so `FB.*` is always there too.
- **Identical to the header's names.** A `containers.Map( of string, long )` *is* an
  `FB.Map( of string, long )`. A program may also `#include` the header directly, and there
  is still one copy.
- **Not yet seen by the tooling.** tiko-lsp's completion and the editor's parser list a
  module's public symbols, and exported macros are not symbols.

**Left out:**
- `fb/select.bi`, which is what a `SELECT` statement lowers to;
- the headers' internal helpers;
- `fb/sharedptr.bi`, which fits none of the modules;
- the global `DT_*` constants of `fb/chrono.bi`, which are not in `FB` and need no module to
  be reached.

## Moving from the pilot

`std/strings` and `std/path` were hand-written modules until RFC-0009 (M30, M31). They now
have the header's behaviour:

| Before | Now |
|---|---|
| `strings.Repeat( s, n )` | `strings.Repeat( n, s )`: the count comes first |
| `strings.Split( s, sep, parts( ) )` returned a count | `strings.Split( s, sep )` returns an `FB.Array( of string )` (`.Count( )`, `[i]`) |
| `StartsWith`, `EndsWith`, `Contains`, `Replace` | the same, plus an optional `ignoreCase` |
| `#import "std/path"` | `#import "std/fs"`: `Separator`, `JoinPath`, `DirName`, `BaseName`, `Extension`, `IsAbsolute` are kept as names for `PathSeparator`, `PathJoin`, `PathParent`, `PathFileName`, `PathExtension`, `PathIsAbsolute` |
| `IsAbsolute( "/x" )` was true on Windows | false: a rooted path without a drive is not absolute there, and `"C:\x"` is |
| `DirName( "a/b/" )` was `"a/b"`; `BaseName( "a/b/" )` was `""` | `"a"` and `"b"`: a trailing separator is ignored |
| `JoinPath( "a", "/b" )` was `"a\/b"` | `"/b"`: a rooted second part replaces the first |
| `Extension( "a." )` was `"."` | `""` |

## Regenerating

The facades are written by `build/genfacades.py` from the headers themselves. It uses
`tiko --dump-scan`, so the names come from the compiler, not from a text search. Re-run it
from the repository root whenever a header changes, and commit the result:

```sh
python build/genfacades.py            # rewrite every facade
python build/genfacades.py --check    # exit 1 if one would change
```

`strings/surround.bas` is hand-written and is left alone.

`build/package.sh --verify` builds and runs one value from every facade, per target, so a
header that renames or drops an exported name fails the packaging run.
