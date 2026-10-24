# std

The tiko standard package: modules shipped with the compiler, imported as
`#import "std/strings"`. `std` always resolves here, never to a project's own package of
that name (RFC-0007 §3, §5).

## The modules

Each module is a **real module** (ADR 0017): compiled once, cached, initialised in import
order, and the one copy of its code. Until 2026-10-10 they were facades over header
libraries in `inc/fb`; that directory is gone, and its code lives here.

| Module | Holds | Needs |
|---|---|---|
| `std/strings` | string algorithms: `Split`, `Join`, `Replace`, `Tally`, `PadLeft`, CSV, …; `Format` (C++ `std::format`) | |
| `std/fs` | paths, directories, files, globs, links, volumes, and `std/path`'s old names | |
| `std/containers` | `Array`, `Map`, `Set`, `LinkedList`, `OrderedMap`, `OrderedSet`, `PriorityQueue`, `Deque`, `BitSet`, `Sort`, `BinarySearch` and the other searches, `HashOf`, `Hashable` | |
| `std/chrono` | `DateTime`, `LocalDate`, `TimeSpan`, `Instant`, `Stopwatch`, `WallClock`, the `DT_` constants | |
| `std/tasks` | `Channel`, `WaitGroup`, `Context`, `Spawn` -- and what `spawn` and `select channel` lower to | `-mt` |
| `std/outcome` | `Optional`, `Result`, `Some`, `None`, `Ok`, `Fail` | |
| `std/numeric` | math, checked integers, complex, text formatting, random, statistics, fenv, vectors | |
| `std/money` | `Decimal`, `Currency`, `MoneyFormat`, the finance library | |
| `std/logs` | `Logger`, sinks, renderers, the default logger, and the logging macros | |
| `std/tui` | the terminal UI library | |
| `std/memory` | `SharedPtr`, `WeakPtr`, `MakeShared` | |
| `std/codec` | base64, base32, hex, percent-encoding; endian get/put; LEB128 varints | |
| `std/uuids` | `Uuid`, `NewV4`, `NewV7`, `Parse` | |
| `std/hash` | `Hasher`: CRC-32/32C, Adler-32, FNV-1a, xxHash64, MD5, SHA-1, SHA-2; `Hmac( of H )`; `DigestFile` | |
| `std/os` | `Args`, `GetEnv`/`SetEnv`/`Environment`/`ExpandEnv`, host facts, `ExitWith`, `CatchInterrupt` and the interrupt flag | |
| `std/process` | `Command`, `Child`, `PipeStream`, `ExitStatus`, `Run`, `Capture`, `Shell` | |
| `std/net` | `IpAddress`, `SocketAddress`, `Resolve`, `TcpStream` (an `fs.Stream`), `TcpListener`, `UdpSocket`; `Url`, `QueryValues`, `ParseUrl`, `ParseQuery` | |
| `std/tls` | `TlsStream` (an `fs.Stream`: `ConnectHost`, `Connect`, `Accept`), `TlsConfig`; SChannel on Windows, OpenSSL 3 loaded at run time on Linux | |
| `std/http` | `Client` (`Fetch`, `Head`, `Post`, `Send`, `Open`), `Request`, `Response`, `ResponseStream`, `Headers`; `Fetch`, `Post` | |

**How a module's names are used:**
- **Qualified, or through `using`.** `strings.Replace( s, "a", "b" )`, or `using strings` and
  then `Replace( s, "a", "b" )`. Two modules that both export a name -- `strings.Contains` and
  `containers.Contains` -- need qualifying when both are `using`ed (TKO0919).
- **Macros are exported and used qualified**: `logs.LogInfo( "started" )`,
  `logs.LogEventWarn( AddText( "path", p ), "write failed" )`, and std/fs's `JoinPath`, `DirName`,
  `BaseName`, `Extension`, `IsAbsolute`, `Separator`. `using` never makes a macro bare.
- **A key type for `Map` or `Set`** extends `containers.Hashable` and overrides its
  `HashOf( )`; it needs `=` too (and `OrderedMap`/`OrderedSet` need only `<`). Built-in types
  are hashable already.
- **`spawn` and `select channel` need `#import "std/tasks"`** in the file that uses them, and
  `-mt` (TKO0423 says so).

**Settings.** `std/logs` elides log calls below `LOG_MIN_LEVEL` at compile time (10, everything,
when unset); a module never sees its importer's `-d`, so it is set in a `tiko.toml`'s
`[defines]`.

## Moving from the facades and headers

| Before | Now |
|---|---|
| `#include once "fb/string.bi"` + `using FB` | `#import "std/strings"` + `using strings` |
| `#include once "containers.bi"`, `FB.Array( of T )` | `#import "std/containers"`, `containers.Array( of T )` |
| `#import "std/x"` + `using FB` | `#import "std/x"` + `using x` |
| `HashOf` overload added in `namespace FB` | `type K extends containers.Hashable` with a `HashOf( )` override |
| `FB_LOG_INFO( m )` and the other `FB_LOG_*` macros | `logs.LogInfo( m )`, `logs.LogEventWarn( f, m )`, ... |
| `FB_LOG_IMPLEMENT( )` in one module | nothing: the default logger is std/logs' own |
| `FB_LOG_MIN_LEVEL` | `LOG_MIN_LEVEL`, std/logs' setting |
| LogEvent's `.Str( )`, `.Int_( )`, `.UInt( )`, `.Dbl( )`, `.Bool( )`, `.Ptr_( )`, `.Time( )`, `.Span( )`, `.Val( )`, `.Err( )` | `.AddText( )`, `.AddInt( )`, `.AddUInt( )`, `.AddFloat( )`, `.AddBool( )`, `.AddPtr( )`, `.AddTime( )`, `.AddSpan( )`, `.AddValue( )`, `.AddError( )` |
| `#include once "fb/sharedptr.bi"` | `#import "std/memory"` |
| `#include once "fbsqlite.bi"` + `using SQLite` | `#import "vendor/sqlite3"`: no wrapper, SQLite's own C API |
| ComPtr (`fb/comptr.bi`) | no longer supported |

## The tests

`tests/std` holds fbc's own tests of these libraries, ported from `tests/vendor` (which is never
edited) by `build/stdtests.py`, with `tests/std/baseline` recording what the originals did over
the headers; `build/stdsuite.sh` compares the two. `build/package.sh --verify` builds and runs one
value from every module, per target.
