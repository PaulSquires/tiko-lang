<div align="center">

# tiko-lang

**A FreeBASIC compiler with a portable Unicode string type, generics, an iterator protocol, `FOR EACH`, tuples and multiple return, a standard container library, a modern date/time library, a modern filesystem library, `defer`, and lambdas — built on fbc 1.20.0, with the existing language left untouched.**

[![Version](https://img.shields.io/badge/fbc-1.20.0-blue)](#)
[![Targets](https://img.shields.io/badge/targets-win64%20%7C%20win32%20%7C%20linux--x86__64-green)](#)
[![Tests](https://img.shields.io/badge/unit--tests-1%2C596%2C104%20assertions-brightgreen)](#tests)
[![Licence](https://img.shields.io/badge/licence-GPLv2%2B%20%2F%20LGPLv2.1%2B-lightgrey)](#-license)
[![Status](https://img.shields.io/badge/status-complete%2C%20offered%20upstream-orange)](#-project-goals)

[Features](#-key-features) · [Why](#-why-this-compiler) · [Examples](#-example-code) · [Quick start](#-quick-start) · [Ecosystem](#-ecosystem) · [Docs](#-documentation)

</div>

---

## About this project

I am Paul Squires of [PlanetSquires](https://www.planetsquires.com). I've been a programmer most of my life and for over the past 20 years I have used the [FreeBASIC](https://www.freebasic.net) programming language amongst a host of other popular languages. I have always envied features from some of those other languages that FreeBASIC lacked. Luckily, with the help and power of AI, I am now able to add those features to FreeBASIC in a way that helps the language approach or exceed its brethren. Without the depth of analysis, speed of implementation, and the quality of code generated that modern AI affords us, it would have taken me a long time as a solo developer to add all of the amazing features available in this fork of FreeBASIC.

<table align="center">
<tr><td align="center">

🎯 &nbsp;**THE GOAL**

**This fork is a *provable testing ground* for the new features —<br>
so that one day they may be added to the canonical FreeBASIC code base as desired.**

**Ultimately, my goal is for this project to cease to exist because all of tiko-lang's<br>
features will have found their way into the core FreeBASIC compiler project.**

</td></tr>
</table>

tiko-lang is a modified copy of the [FreeBASIC](https://www.freebasic.net/) compiler that adds language features, each built on the one before it: **generics**, a **structural iterator protocol**, **`FOR EACH`**, **tuples** so a function can return more than one value, a **standard container library**, **`defer`** for scope-exit cleanup, and **lambdas** with optional capture — plus **`USTRING`**, a dynamic Unicode string type that is byte-identical on every target, **`fb/chrono.bi`**, a date/time library that replaces the VB6 serial-`double` model with ticks, durations, clocks and ISO 8601, and **`fb/filesystem.bi`**, which replaces the 1985 BASIC file surface with a path algebra, a stat record, a reentrant directory walk and whole-file I/O.

It is for **existing FreeBASIC users** who want their code to keep compiling unchanged, **systems programmers** who want typed containers without a runtime, **library authors** who have been writing the same `Vector` five times, and **compiler people** who want to see a template system implemented as parser replay rather than as a separate template language.

Everything here is **purely additive**. `STRING`, `ZSTRING`, `WSTRING`, `FOR`, and the existing `OPERATOR FOR/NEXT/STEP` protocol are unchanged; `each`, `in` and `defer` are not reserved words; the containers add nothing to the global namespace. If your program compiles with fbc 1.20.0, it compiles here — with one stated exception, a paren-less call in statement position to a sub named `defer`.

<table align="center">
<tr><td align="center">

⚠️ &nbsp;**YOUNG PROJECT — EXPECT BUGS**

**tiko-lang is new. The features described here are recent work,<br>
and every one of them touches a compiler that has been stable for decades.**

**Expect unexpected bugs, rough edges, incomplete diagnostics and breaking changes<br>
between versions. Do not put this compiler in the path of anything you cannot afford<br>
to have break. Test your code, keep fbc 1.20.0 nearby, and please report what you find.**

</td></tr>
</table>

> **Scope, stated plainly.** This is fbc 1.20.0 with several new modern features added and one caveat (see [Tests](#tests)). It is not a rewrite, not a new parser, and not a performance project. Where a capability does not exist, this README says so instead of implying it.

---

## ✨ Key Features

| Feature | What it is |
|---|---|
| **Generics** | `type Box( of T )` and `function Max( of T )( … )`. Bodies are captured as token chains and replayed through the real parser once per type-argument list — so code inside a generic is ordinary FreeBASIC and is diagnosed as such. Not a macro, not a separate template language. |
| **Iterator protocol** | A *structural* contract: a type is iterable if it has `GetIterator( )` returning something with `IsValid( )`, `Value( )` and `MoveNext( )`. No base class, no interface, no registration, nothing to inherit. |
| **`FOR EACH`** | Walks arrays (any `lbound`), var-len `STRING`, and any type satisfying the protocol. Lowered at compile time — no new AST node, no IR node, no backend change, no runtime call. |
| **Tuples** | `as (long, string)` — an anonymous aggregate identified **structurally**, so `(long, string)` is one type in every module. Gives FreeBASIC multiple return: `function MinMax( ) as (min as long, max as long)`, then `var (lo, hi) = MinMax( )`. No new token, no new datatype, no IR or backend change — a tuple is an ordinary UDT with fields `_1.._N`, so layout, copy, destruction and the return ABI are the paths fbc already had. |
| **String library** | 39 algorithms FreeBASIC does not ship — `Replace`, `Split`, `Join`, `Between`, the pad family, the character-set family, an RFC-4180 `SplitCsv` — in namespace `FB`, working on **all four string types** from one call. Implemented in the runtime, but **nothing becomes a keyword**. |
| **`defer`** | `defer <statement>` runs on the way out of the enclosing **scope**, in reverse order, on **every** path — fallthrough, `exit`, `return`, `goto` out of nested scopes — and every iteration of a loop body. For the one-off `CloseHandle` that does not justify declaring a type. A **contextual keyword**: existing code using `defer` as a name keeps working. |
| **Lambdas** | `function( byval x as long ) as long … end function` in expression position. Non-capturing ones are **plain procedure pointers**, so every existing callback API — including `cdecl`/`stdcall` ones like `qsort` and Win32 — works unchanged. Capturing ones, `sub[ byref total ]( … )`, build a stack closure; every capture states `byval` or `byref` explicitly. |
| **`Optional` / `Result`** | `Optional( of T )` for a value that might not be there, `Result( of T, E )` for a value or the reason there isn't one. Pure library, no compiler support. Zero is a value; a default-constructed `Result` is a **failure**, so a forgotten assignment cannot read as success. |
| **`SharedPtr` / `WeakPtr`** | `fb/sharedptr.bi` — shared ownership by reference count, destroyed exactly once when the last handle goes. `sp->field` and `*sp` work through **global generic operators**. `WeakPtr` observes without keeping alive, which is the only way to break a cycle, and its `Lock( )` is an increment-only-if-not-zero done as a single compare-and-swap. Counts are **atomic under `-mt`** via three new runtime functions — not the four-backend `FB.Atomic( of T )` RFC, just the primitives a refcount needs. Derived→base is the explicit `SpCast( of D, B )`, and the base needs a **virtual destructor**. |
| **`ComPtr` (COM)** | `fb/comptr.bi` — an ATL-style smart pointer that owns a COM interface reference and releases it on **every path out**, plus `ComQIPtr` (QueryInterface on assignment), `ComQI`/`ComQIAs`/`ComCast`, `ComCreate`, `ComInit`, `ComHeapPtr` and the connection-point helpers. Entirely a header: a COM object already counts its own references. Departs from ATL deliberately — `Get( )` is **explicit** where ATL's implicit `T*` conversion is what makes ATL code leak, `PutRef( )` **raises** on an already-owning pointer where ATL only asserts in debug, and derived→base is a real **`QueryInterface`** rather than a cast, because two interfaces on one object need not share an address. There is no `__uuidof`, so one `COM_IID( iface, iid )` line per interface supplies the IID. |
| **Date/time** | `fb/chrono.bi` — `DateTime`, `LocalDate`, `LocalTime`, `Instant`, `TimeSpan`, `WallClock`, `Stopwatch`, `CpuClock`, `TimeZoneInfo`. Immutable value types over `int64` ticks of 100 ns, years 1–9999. ISO 8601 / RFC 3339, custom patterns, OS-native offsets and DST, a monotonic clock. **Arithmetic never wraps**; out-of-range gives an `Invalid` sentinel. Ships **alongside** `datetime.bi`, which is unchanged; the two meet at `FromSerial` / `Serial`. |
| **Filesystem** | `fb/filesystem.bi` — path algebra, `FileInfo`, a **reentrant** directory iterator that works with `FOR EACH`, a recursive walk, whole-file text and byte I/O, `mkdir -p` / `rm -rf` / tree copy, glob, atomic replace, temp files, symlinks and permissions, volumes, plus file watching, memory mapping and advisory locking. Every fallible call returns `Result( of T, FsError )`. Ships **alongside** `Dir`/`FileExists`/`Kill`, which are unchanged. |
| **Goroutines & channels** | `spawn Worker( a, b )` runs a procedure concurrently with its **arguments copied at the spawn point**, so `for i = 1 to 10 : spawn Work( i ) : next` gives each goroutine its own `i`. `Channel( of T )` is a typed queue — rendezvous or buffered, with a close protocol and `for each v in ch`. `select channel` waits on several channels at once, `WaitGroup` joins a fan-out, `Context` cancels one. Two parser files, **no AST node, no IR node, no backend change**. Not Go's *cheap* goroutine: thousands, not millions. |
| **Standard containers** | `Array`, `Map`, `Set`, `LinkedList`, `OrderedMap`, `OrderedSet` in namespace `FB`. Written in ordinary FreeBASIC on top of the three features above, with **zero compiler support** — so a better implementation by anybody else is on exactly equal footing. |
| **Ordered containers** | `OrderedMap` and `OrderedSet` are **red-black trees**: `O(log n)`, always in ascending key order, with `TryFirst`/`TryLast`/`TryFloor`/`TryCeiling` on top of the hash containers' interface. They need only `<` on the key — **no hash and no `=`** — so a type that can be ordered but not hashed is usable as a key. Iterators survive insertion, which a rehash cannot promise. |
| **Sorting** | `Sort( a )` is an **introsort** — quicksort, falling back to heapsort at depth `2·⌊log₂ n⌋` and to insertion sort below 16 elements, so `O(n log n)` worst case, in place. `StableSort( a )` is a bottom-up merge sort. `SortList( l )` relinks a `LinkedList`'s nodes and moves no element. Every form takes an optional comparer, including a **capturing lambda**. Every move is a `SWAP`, so sorting an `Array( of string )` performs zero string copies. |
| **`#cinclude` (C importer)** | `#cinclude once "sqlite3.h"` uses a C library's **own header** instead of a hand-written binding: the header goes to **Clang**, and what comes back becomes FreeBASIC declarations for the target being built. Structs, unions, enums, typedefs, function pointers, variadics, globals and object-like macros. It emits **text** and lets fbc compute the layout itself, so Clang and fbc can be **compared** — a disagreement is a compile-time error naming the record and the first differing member. `windows.h` is ~35,000 declarations with all 2,517 records verified. libclang is loaded on first use via `DyLibLoad`, never linked; fbc builds and runs without it. Also `-cimport`/`-cimport-out` to generate a binding as a **deterministic** file you can diff across an SDK upgrade. Function-like macros are deliberately **not** translated. |
| **`#foreignlib`** | `#foreignlib SQLITE dynamic "vendor/sqlite3"` binds a name to a library **shipped inside your source tree** — resolved relative to the *declaring file*, not the working directory, with the target variant picked by filename convention (`sqlite3_windows_x86_64.dll.a`, `sqlite3_linux_x86_64.so`). `static`/`dynamic` is **mandatory**; a file of the other kind is an error, never a silent substitution. Declarations then say `lib SQLITE` instead of a string literal, so a cross-platform binding stops duplicating every `Declare` inside `#ifdef`. `#inclib` and `#libpath` are unchanged. |
| **`USTRING`** | A dynamic Unicode string that is UTF-16 on *every* target, unlike `WSTRING` (2 bytes on Windows, 4 on Linux, 1 on DOS). A true intrinsic type in the compiler, not a library — `LEN` is O(1) and every string intrinsic works. |
| **Backwards compatibility** | Nothing existing changes. Verified by fbc's own suite — 1,154,412 assertions of it, plus this project's own suites on top — across four dialects, under **both** backends. |
| **Diagnostics** | New, specific messages for the new features — including the **instantiation chain** for an error inside a generic, and near-miss reporting that names the *missing member* rather than saying "not iterable". Diagnostics elsewhere are byte-identical to stock fbc. |
| **Unicode** | UTF-8 ↔ UTF-16 conversion fixed on every target (not locale-dependent), a generated BMP case-mapping table, and UTF-8 file output everywhere. |
| **Cross-platform** | Built, tested and shipped prebuilt for **win64**, **win32** and **linux-x86_64**. 32-bit x86 was dropped on Linux only. |
| **Backends** | All of fbc's backends carry the work, and all four are first-class: `gcc` (C emission), `gas64`, `gas` (x86 32-bit), and `llvm`. Every feature in this table works on every backend on every supported target. |
| **LLVM backend** | **`-gen llvm` is a complete, full-featured backend, on par with `gas`, `gas64` and `gcc`** — not a partial or experimental path. It is a **rewrite**: it emits current LLVM IR and hands it to `clang -c`, with a hand-written C ABI classifier per target, and covers **win64, win32 and linux-x86_64**. It passes fbc's own unit-test gate on all three targets with **the same assertion counts and the same failures as `-gen gcc`** ([baseline](docs/tests/llvm/BASELINE.md)). **All you need is clang**: install the LLVM package for Windows, or your distribution's `clang`/LLVM package on Linux, so that `clang` (18 or newer) is on `PATH` — nothing is bundled and nothing else is required. The one deliberate difference: inline `ASM` and `NAKED` are **rejected with a real diagnostic** rather than miscompiled, because FB's raw gas text has no faithful LLVM IR equivalent. |
| **Prebuilt compilers** | Ready-to-run Windows and Linux installations are committed to the repository. No bootstrap required to try it. |

---

## 🤔 Why This Compiler?

Against **stock fbc 1.20.0**. Only rows where something actually changed:

| Stock FreeBASIC 1.20.0 | tiko-lang |
|---|---|
| A container works for one element type, or uses macros / `ANY PTR` | `Array( of T )` — one implementation, fully type-checked per instantiation |
| Generic code via `#define`, diagnosed at the expansion with no scope | Generic bodies are real FreeBASIC, diagnosed at the body **plus** the instantiation chain that reached it |
| Every traversal is an index loop; `lbound` vs `0`, `ubound` vs `count-1` | `for each x in c` — over arrays, strings, and any user collection |
| Growable array means `redim preserve` per append — **O(n²)** over a loop | `Array.Push` is amortised **O(1)**; capacity doubles instead of reallocating on every append |
| No portable Unicode string: `WSTRING` is 2/4/1 bytes by platform, and fixed-length | `USTRING` — dynamic, UTF-16 everywhere, `LEN` O(1) |
| `WSTRING` append walks to the terminator: **O(n²)** | `USTRING` keeps its length in the descriptor: **O(1) amortised** — 400–900× faster at n=40,000 ([numbers](#performance-appending)) |
| `STRING` ↔ `WSTRING` conversion goes through the C locale — codepage- and machine-dependent | `STRING` ↔ `USTRING` is UTF-8 on every target, identical everywhere |
| A ustring-shaped file written on Windows is not what Linux writes | Files, pipes and non-Windows consoles get **UTF-8** on every platform |
| Dates are serial `double`s at second resolution — no duration type, no offset, no ISO 8601, no monotonic clock | `fb/chrono.bi` — 100 ns ticks, `TimeSpan`, UTC offsets and DST, ISO 8601 / RFC 3339, `Stopwatch` |
| `DateSerial( 2025, 13, 40 )` silently normalizes; a bad parse is indistinguishable from a valid one | Out-of-range construction returns `Invalid`; parsing is `TryParse` and **strict**; arithmetic never wraps |
| Returning two values means a `byref` out-parameter, a one-off `TYPE`, or a shared global | `function MinMax( ) as (min as long, max as long)` and `var (lo, hi) = MinMax( )` — and `for each (k, v) in map` |
| `Dir`/`DirNext` keep **one cursor per thread**, so two interleaved scans corrupt each other and recursion needs buffering | `ReadDir`/`WalkDir` — every iterator owns its handle; nesting and recursion are simply correct |
| No path manipulation at all: no join, split, normalize, extension or parent — every program hand-rolls it, and gets UNC and trailing separators wrong | `PathJoin`, `PathNormalize`, `PathRelativeTo` and the rest — pure, both grammars, exhaustively tested |
| Four calls (`FileExists` + `FileAttr` + `FileLen` + `FileDateTime`) to learn four facts, with four race windows | One `Stat` fills one `FileInfo` |
| `Kill` on a read-only file just fails; `Name` across volumes just fails; neither says why | `FsError` carries a portable code, the native code, the path and the operation — and `MoveFile` falls back to copy+delete |

Everything not in this table is deliberately identical, including diagnostics, code generation and compile times.

---

## 💻 Example Code

### Generics

```basic
type Box( of T )
    as T value
end type

type Pair( of K, V )
    as K k
    as V v
end type

dim b as Box( of long )
dim s as Box( of string )          '' a distinct, unrelated type
dim n as Box( of Box( of long ) )  '' nesting is fine

function Max( of T )( byval a as T, byval b as T ) as T
    if a > b then return a
    return b
end function

print Max( 3, 9 )                  '' T inferred from the arguments
print Max( of double )( 1.5, 2.5 ) '' or given explicitly
```

Out-of-line member bodies, constructors, operators and inheritance all work, and **declaration order does not matter**:

```basic
type Stack( of T )
    as T items( 0 to 15 )
    as integer count
    declare sub Push( byval x as T )
    declare operator [] ( byval i as integer ) byref as T
end type

sub Stack( of T ).Push( byval x as T )
    this.items( this.count ) = x
    this.count += 1
end sub

operator Stack( of T ).[] ( byval i as integer ) byref as T
    return this.items( i )
end operator
```

### Errors point at the instantiation that caused them

```
box.bas(13) error 14: Expected identifier, found 'Wdiget'
  in instantiation of 'Box( of long )'
  required from box.bas(18)
```

### `FOR EACH`

```basic
dim names(0 to 2) as string = { "ada", "grace", "edsger" }

for each n as string in names       '' a copy of each element
    print n
next

dim values(0 to 3) as long = { 1, 2, 3, 4 }

for each byref v as long in values  '' a reference — this modifies the array
    v *= 2
next
```

Any type with three members becomes iterable — no inheritance, no interface:

```basic
type MyIter
    declare function IsValid( ) as boolean
    declare function Value( ) byref as long
    declare sub MoveNext( )
end type

type MyList
    declare function GetIterator( ) as MyIter
end type

for each v in myList                '' just works
    print v
next
```

### Tuples and multiple return

```basic
declare function MinMax( a( ) as long ) as (min as long, max as long)

var (lo, hi) = MinMax( values( ) )     '' declares two locals, one per element

dim x as long, y as string
(x, y) = GetPair( )                    '' or assign to existing ones

(a, b) = (b, a)                        '' the right side is bound first, so this swaps
```

Identity is **structural**, and element names are documentation rather than part of the
type — so the two spellings below are the same type, and a tuple written in two modules
links:

```basic
dim a as (long, long)
dim b as (min as long, max as long)
a = b                                  '' same type
print b._1, b._2                       '' fields are _1 .. _N

if (1, "x") = (1, "x") then           '' element-wise '=' and '<>'
```

And a collection whose `Value( )` yields a tuple destructures in the loop header, which is
what makes a map read the way a map should:

```basic
for each (key, value) in dictionary
    print key, value
next
```

### Containers

```basic
#include once "containers.bi"
using FB

dim names as Array( of string )
names.Push( "ada" )
names.Push( "grace" )
names.Insert( 0, "hopper" )

dim ages as Map( of string, long )
ages[ "ada" ] = 36

dim seen as Set( of long )
seen.Add( 3 )

for each n in names
    print n, ages.Contains( n )
next

'' The sorted pair. Same interface, always in key order, and they need
'' only '<' on the key -- no hash, no '='.
dim byVersion as OrderedMap( of string, long )
byVersion.Put( "1.10", 2 )
byVersion.Put( "1.2", 1 )

for each kv in byVersion              '' "1.10" then "1.2", always
    print kv.key, kv.value
next

dim nearest as string
byVersion.TryFloor( "1.5", nearest )  '' largest key <= "1.5"
```

> **Four things to know.** `Array` indices are **zero-based**. `Map`'s indexer `m[ k ]` **inserts on a miss** — use `TryGet` or `Contains` to read, and `OrderedMap`'s behaves the same. Copy and assignment are **deep** for all six containers; the language has no move constructor, so pass them `byref` where it matters. And reach for `OrderedMap`/`OrderedSet` when you want the **order** — they are `O(log n)` where the hash versions are `O(1)`, and measurably slower at every size.

### String library

```basic
#include once "fb/string.bi"
using FB

print Replace( "Hello World", "World", "Earth" )   '' Hello Earth
print Between( "log(42) end", "(", ")" )           '' 42
print PadLeft( "42", 6, "0" )                      '' 000042

dim parts as Array( of string ) = Split( "a,b,c" )
print parts.Count( ), Join( parts, " | " )         '' 3    a | b | c

'' a quoted comma is content -- what splitting on commas can never get right
dim rows as Array( of CsvRow ) = SplitCsv( !"a,\"b,c\"" )
print rows[ 0 ].fields[ 1 ]                        '' b,c

'' the same calls take a ustring, a wstring or a zstring — the first
'' argument picks the family, and you never name it
dim as ustring u = "café noir"
print Replace( u, "noir", "au lait" )
```

`Join( Split( s, d ), d )` is `s` for every `s`. Positions are 1-based like
`INSTR`; `Split` never drops a field. `SplitCsv` finds records and fields in the
same pass, so a newline inside a quoted field is content, and answers **zero
rows** when a quote is never closed. Eleven deliberate differences from the
AfxNova originals, plus two AfxNova bugs found by the differential harness, are
listed in [docs/string/string.txt](docs/string/string.txt).

### Date and time

```basic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( 330 )
print d.ToIsoString( )                      '' 2025-03-04T14:30:05+05:30
print d.ToString( "dddd, dd MMMM yyyy" )    '' Tuesday, 04 March 2025

dim as DateTime bad = DateTime( 2025, 2, 30 )
print bad.IsValid                           '' false — not a normalized 2025-03-02

dim as TimeSpan age = WallClock.UtcNow( ) - d.ToInstant( )
print age.TotalDays

dim as Stopwatch sw = Stopwatch.StartNew( )  '' monotonic; TIMER is not
'' … work …
print sw.ElapsedMilliseconds
```

> **Four things to know.** Values are **immutable** — `AddDays` returns a new one. Out-of-range construction and overflow give the `Invalid` sentinel rather than wrapping or erroring, and `Invalid = Invalid` is **false**, so test with `IsValid`. Parsing is strict `TryParse`, never a locale guess. `DateTime.FromSerial` / `.Serial` bridge to legacy `datetime.bi` doubles, so migration is per-function.

### Filesystem

```basic
#include once "fb/filesystem.bi"
using FB

'' Path manipulation is pure string work -- no syscalls, no disk.
dim as string src = PathJoin( "C:\dev", "tiko", "src" )   '' C:\dev\tiko\src
print PathExtension( "frmMain.bas" )                       '' .bas
print PathStem( ".gitignore" )                             '' .gitignore -- a dotfile has no extension

'' One stat answers every question about one object.
dim as FsResultInfo info = Stat( src )
if( info.IsOk( ) ) then
    print info.Value( ).Size( ), info.Value( ).IsDirectory( )
else
    '' the failure says WHICH failure, and on what
    print info.Failure( ).Message( ), info.Failure( ).Path( )
end if

'' A recursive walk, over FOR EACH. Each element is a Result, so a
'' subdirectory you cannot read is YIELDED rather than silently skipped.
for each entry in WalkDir( src )
    if( entry.IsOk( ) ) then
        if( PathExtension( entry.Value( ).Name( ) ) = ".bas" ) then
            print entry.Value( ).Path( )
        end if
    else
        print "skipped: "; entry.Failure( ).Path( )
    end if
next

'' Whole-file I/O, one line each. ReadAllText honours a BOM and assumes
'' UTF-8 when there is none.
dim as FsResultUStr text = ReadAllText( PathJoin( src, "frmMain.bas" ) )
WriteAtomic( "config.ini", "[main]" & chr(10) )   '' readers never see a partial file

'' Glob, mkdir -p, rm -rf.
dim as Array( of ustring ) hits
Glob( PathJoin( src, "**", "*.bas" ), hits )
CreateDirAll( "build\win64\obj" )
RemoveDirAll( "build" )                            '' unlinks symlinks, never descends them
```

> **Four things to know.** Every fallible call returns `Result( of T, FsError )` — there is no `err()`, and a default-constructed result is a **failure**, so a forgotten assignment cannot read as success. Iterators own their handles, so `ReadDir`/`WalkDir` nest and recurse correctly where `Dir`/`DirNext` cannot. `WalkDir` does **not** follow directory symlinks by default, which is what makes `RemoveDirAll` safe. And paths coming *out* are `USTRING`: narrowing them to `STRING` is UTF-8 and lossy, so keep filesystem-sourced paths wide.

### `USTRING`

```basic
dim as ustring u = "héllo"          '' dynamic, grows on demand
u += " wörld"                       '' no fixed capacity to overflow

print len(u)                        '' 11 code units, O(1)
print ucase(u)                      '' HÉLLO WÖRLD
print mid(u, 7, 5)                  '' wörld

'' On Windows a ustring already IS UTF-16 — passing it to a wide API
'' is a pointer reinterpret with no conversion and no copy.
MessageBoxW( null, u, u, 0 )
```

---

## 🚀 Quick Start

Prebuilt compilers are committed to the repository. Clone it and run one.

> **Run `fbc` where it lives.** It derives its installation prefix from its own path, so the binary must stay beside its `bin/`, `include/` and `lib/` directories. Copying just the executable elsewhere gives `cannot open linker script file`.

### Windows

```bat
git clone https://github.com/PaulSquires/tiko-lang.git
cd tiko-lang

toolchains\tiko-windows\fbc64.exe hello.bas
toolchains\tiko-windows\fbc32.exe hello.bas
toolchains\tiko-windows\fbc64.exe -target win32 hello.bas
```

The Windows tree is the standard FreeBASIC **standalone** layout: both compilers sit at the top level and share one `bin/` and one `inc/`, each picking the toolchain and runtime matching its target. Nothing to install and nothing to add to `PATH`.

### Linux (x86-64)

```bash
git clone https://github.com/PaulSquires/tiko-lang.git
cd tiko-lang

toolchains/tiko-linux/bin/fbc hello.bas
./hello
```

A **native** Linux build, not a cross-compile — produced through fbc's own bootstrap path. The binary is committed with its executable bit set; if you extract the tree some other way, `chmod +x toolchains/tiko-linux/bin/fbc`.

### macOS

No macOS build exists — this tree has never been built on darwin. Upstream FreeBASIC supports the target, so the path is likely short, but nothing here is verified. See [Building From Source](#-building-from-source) if you want to try it.

---

## 👋 Hello World

`hello.bas`:

```basic
#include once "containers.bi"
using FB

type Greeter( of T )
    as T name
    declare function Greet( ) as string
end type

function Greeter( of T ).Greet( ) as string
    return "hello, " & this.name
end function

dim people as Array( of string )
people.Push( "ada" )
people.Push( "grace" )

for each who in people
    dim g as Greeter( of string )
    g.name = who
    print g.Greet( )
next

dim as ustring u = "héllo, wörld"
print u, len( u )
```

Compile and run:

```bash
# Windows
toolchains\tiko-windows\fbc64.exe hello.bas
hello.exe

# Linux
toolchains/tiko-linux/bin/fbc hello.bas
./hello
```

Expected output:

```
hello, ada
hello, grace
héllo, wörld           12
```

That one file uses a generic type, an out-of-line generic member body, a container, `for each`, and a Unicode string — with no compiler flags and no build system.

---

## 🎯 Project Goals

1. **Close real gaps in FreeBASIC** — no portable Unicode string, and no way to write a typed container, are just two examples.
2. **Preserve compatibility absolutely.** Existing programs compile unchanged; existing diagnostics are byte-identical; `each` and `in` stay usable as identifiers.
3. **Add to the language, not beside it.** Generics are parsed by the real parser. `FOR EACH` is a desugaring with no new AST or IR node. The containers are a library with no compiler privileges.
4. **Diagnostics that name the actual problem** — the missing iterator member, the instantiation that failed, the type argument that caused it.
5. **Be honest about limits.** Every known limitation is written down, measured, and shipped in the documentation rather than discovered by users.
6. **Offer the work upstream.** This exists to be reviewed and, if the FreeBASIC team wants it, merged — not to become a fork with its own ecosystem.

> **What this project is not aiming at:** a package manager, a language server, an optimizer, or faster builds. Those are worth having; they are not what this is.

---

## 🏗 Compiler Architecture

tiko-lang uses fbc's existing pipeline. Only two stages gained anything.

| Stage | What happens | Changed? |
|---|---|---|
| **Lexer** | Tokens, dialect-gated keywords | `USTRING` added to the keyword table alongside `ZSTRING`/`WSTRING` |
| **Parser** | Single-pass recursive descent, building the AST directly | **Yes** — generic capture and replay, `FOR EACH` lowering, tuple type/literal/destructuring, `spawn` and `select channel` |
| **Symbol / semantic** | `symb*` — types, overload resolution, mangling | **Yes** — instantiation cache, type-parameter binding, Itanium `I…E` mangling for both generic instantiations and tuples |
| **AST** | Expression and statement trees, constant folding | Nearly unchanged — an instantiation and a tuple are both ordinary UDTs by the time the AST sees them; the one addition is the element-wise `=`/`<>` chain for tuples |
| **IR / backends** | `gcc` (C), `gas64`, `gas` (x86), `llvm` | Unchanged for generics; `USTRING` emission added to all four |
| **Runtime** | libfb / libfbmt / libfbgfx | `USTRING` descriptors, codecs and I/O added; the date/time tick kernel, ISO and pattern engines, and the per-OS clock and zone backends added; the filesystem path kernel, glob matcher and text codec, plus the per-OS stat, directory, operation, link, volume, watch, map and lock backends added; nothing for generics |

<details>
<summary><b>How generics actually work</b> — four sentences, because nothing else in fbc looks like this</summary>

1. A generic's body is captured as a **token chain** at declaration and replayed through the **real parser** once per distinct type-argument list, with the type parameters bound as TYPEDEFs in a synthetic namespace. There is no textual substitution and no separate template AST.
2. Member bodies and generic-procedure bodies are **deferred** to the next module-level statement boundary, because an instantiation happens mid-statement and a procedure cannot be opened there. This is also what makes declaration order irrelevant.
3. Every instantiation is built **at module level**, whatever the parser was doing, because a UDT with member procedures is illegal below module level.
4. `for each` is a **desugaring** with two lowerings — an iterator walk for a user collection, an ordinary counter `FOR` for an array or string — so `for each` over an array emits exactly what the hand-written index loop emits.

Instantiations are Itanium-mangled: `$3BoxIiE` demangles to `Box<int>`. Two modules that both write `Box( of long )` mean the same type and link; each keeps a module-private copy, because PE/COFF offers no working COMDAT here (measured — `__attribute__((weak))` produces a weak *external* that silently breaks virtual dispatch).

Full detail: **[docs/generics/generics.txt](docs/generics/generics.txt)**.

</details>

<details>
<summary><b>How tuples actually work</b> — and why they cost the backends nothing</summary>

1. `(long, string)` is **synthesized as an ordinary UDT** with fields `_1.._N`, by the same straight key→lookup→build path array descriptors already use. There is no token replay, because a tuple has no body.
2. It is **interned on a canonical key** built with `symbMangleType`, so an alias of an element and the element itself produce one symbol, and element names never enter the key. That is what makes identity structural.
3. The mangled name is a **pure function of the element types** — an Itanium `I…E` list recovered from the fields — so nothing is written down and nothing is shared: two modules independently derive the same external name and link. `8FBTUPLE2IiiE` demangles to `FBTUPLE2<int, int>`.
4. The synthesis runs **at module level in the global namespace whatever the parser was doing**, exactly as generic instantiation does. A tuple gets synthesized wherever its type is *spelled*, including places no `TYPE` could appear, and building its implicit ctor/dtor anywhere else corrupts the parser — a `TYPE` body did so by crashing the compiler outright.

Because the result is an ordinary UDT, layout, copy, destruction, the procedure-return ABI and debug info are all the paths fbc already had — which is why multiple return needed no code of its own.

Design and rationale, including four things that were built, measured and then reverted: **[docs/tuples/](docs/tuples/)**.

</details>

---

## 🧩 Ecosystem

### Tiko Editor

**[Tiko](https://github.com/PaulSquires/tiko)** is a Scintilla-based FreeBASIC editor and IDE. It keeps its compilers in a `toolchains/` folder and lets you switch between them, so using tiko-lang from Tiko is a copy and a menu selection — no configuration files to edit.

**1. Copy the toolchains.** Take the folders under this repository's `toolchains/` and drop them into Tiko's `toolchains/` folder:

```
tiko-lang/toolchains/tiko-windows/   →   tiko/toolchains/tiko-windows/
tiko-lang/toolchains/tiko-linux/     →   tiko/toolchains/tiko-linux/
```

Copy the folder whole. Each one is a complete, self-contained FreeBASIC installation — compiler, assembler, linker, headers and runtime — and `fbc` locates its own `bin/`, `inc/` and `lib/` relative to where the executable sits.

**2. Select it in Tiko.** Open **Options → Compiler Setup** and choose the toolchain you just added. Tiko's existing toolchains are left in place, so you can switch back at any time.

That is the whole setup. Build and run from Tiko as usual, and generics, `FOR EACH`, the containers and `USTRING` are available.

---

## 🔨 Building From Source

You do **not** need to build anything to use the compiler — see [Quick Start](#-quick-start). Build only if you are changing it.

**Dependencies**

| | |
|---|---|
| A FreeBASIC compiler to bootstrap with | fbc 1.10+ or the prebuilt compiler in this repository |
| GNU make | any recent version |
| A C toolchain | gcc/binutils — MinGW-w64 on Windows, the system toolchain on Linux |
| Optional | `libffi` (for `ThreadCall`), `libstdc++` (for the four `cpp` log-tests) |

**The makefile lives in `src/`, not at the repository root.** `make` from the root reports `No rule to make target 'compiler'`.

```bash
cd src
make compiler -j8 FBC="/path/to/fbc -i /path/to/tiko-lang/src/inc"
```

The `-i` is required here: `fbc` does not auto-resolve `inc/` from `bin/` in this tree.

A full compiler rebuild is roughly **6 seconds at `-j8`** (146 modules). Touching any `.bi` rebuilds everything.

<details>
<summary><b>Full build, runtime included, and the test gate</b></summary>

```bash
cd src
make rtlib gfxlib2 compiler
```

The gate, in order — a phase is not done until all of it is green:

```bash
# unit tests, both backends
cd src/tests && make unit-tests            FBC="…/fbc.exe -i …/src/inc"
cd src/tests && make unit-tests GEN=gas64  FBC="…/fbc.exe -i …/src/inc"

# per-dialect compile-and-run tests
cd src/tests && make log-tests             FBC="…/fbc.exe -i …/src/inc -p /path/to/libstdc++"

# golden diagnostics, five targets each — regenerate, then git diff
cd src/tests/warnings && FBC="…/fbc.exe" bash ./test.sh
cd src/tests/errors   && FBC="…/fbc.exe" bash ./test.sh
```

Traps that have cost this project real time, all documented in [`docs/tests/tools/BASELINE.md`](docs/tests/tools/BASELINE.md):

- make tracks `.bas` → `.o` only, so a changed **compiler** leaves stale objects and the suite silently re-runs the previous binary. Force a rebuild.
- A new test **file** needs `make clean-tests` from `src/`; a new test **directory** needs `tests/dirlist.mk` *and* `make clean`.
- Never run two `make log-tests` concurrently — they race and invent failures.
- Reconcile `passed + failed = total logs`. "No failures" on its own proves nothing.

</details>

---

## Tests

fbc has four test targets. All four are run.

| Target | Scale | Result |
|---|---|---|
| `unit-tests` (win64, gcc) | fbc's suite plus this project's | **1,596,104 assertions — 11 failed** |
| `unit-tests` (win64, gas64) | same | **identical** |
| `log-tests` | 1,731 tests across `fb`, `fblite`, `qb`, `deprecated` | **1,731 passed, 0 failed** |
| `warning-tests` | 68 files × 5 targets | **0 diagnostic changes** |
| `goroutines` suites | 8 suites, win64 + win32 + linux-x86_64 | **457 checks per platform, 0 failed** |
| `error-tests` | golden diagnostics × 5 targets | **0 diagnostic changes** |

The 11 failures are all `fbc_tests.threads.threadcall_`, caused by `libffi` being absent in this build environment — **present in the baseline before any of this work**, and reproduced at `main` with the changes stashed.

`warning-tests` compiles for **dos, linux-x86_64, win32 and win64** and compares against committed reference output, so every diagnostic on every target is byte-identical to stock fbc except the ones deliberately added.

> **Note on the `linux-x86` figures above and below.** These results were recorded *before* 32-bit x86 was dropped on Linux. They are kept as the historical record of those runs; they are not claims about currently supported targets, which are **win64**, **win32** and **linux-x86_64**.

**This project's own suites**

| Suite | Covers |
|---|---|
| `src/tests/generics/` | 68 files — instantiation and identity, out-of-line members, operators and properties, generic procedures and inference, global operators, all three inheritance directions with `VIRTUAL`/`ABSTRACT`/RTTI, self-reference, mangling, deferral, multi-module linking, every container member and complexity claim, the sort library, the red-black trees' **invariants** after every destructive phase plus a differential stress against the hash containers, and 29 one-case diagnostic files |
| `src/tests/chrono/` | 8 fbcunit suites — ticks and components, `TimeSpan`, calendar arithmetic, clocks, ISO 8601, patterns, zones and locale, the `USTRING` overloads. Plus `docs/tests/datetime/dt_core_test.c`, a standalone C harness: **23,304,597 checks**, including an exhaustive civil↔tick round trip over all 3,652,059 days in range |
| `src/tests/filesystem/` | 9 fbcunit suites, **1,161 assertions across 167 tests** — the path algebra (every rule of the spec, under **both** path grammars regardless of host), the error codes cross-checked against their C constants, `Stat` and the reentrant iterator, the walk and the bulk operations, glob, links and permissions, volumes, watching/mapping/locking, and the whole `STRING` overload layer |
| `docs/tests/ustring/ustring_*.bas`, `docs/tests/ustring/ustr_*.c` | 464 checks — the language surface, every declaration form, I/O and encodings, `DRAW STRING` compared pixel by pixel, the codecs against malformed input, and the wchar helpers at **all three wchar widths** |

Behaviour tests are additionally run under **both** backends by hand, and against the **prebuilt** compilers rather than the build tree — 17/17 on win64, win32 and linux-x86_64.

**Not verified**: the LLVM backend for generics (no LLVM toolchain on the build machine, and it is not in the gate), and the macOS, ARM, JS and DOS targets.

> **One caveat, stated plainly.** fbc's suite as shipped does not pass untouched. `tests/udt-wstring` and `tests/udt-zstring` each contain `#define ustring …` in 18 files, which becomes `error 4: Duplicated definition` once `USTRING` is a keyword. They are renamed to `uwstr_t` / `uzstr_t`; any upstream patch has to carry that 36-file rename.

### Performance: appending

`USTRING` moves 2 bytes per character where `STRING` moves 1, so equal *throughput* is parity. Best of three runs:

| Platform | STRING | USTRING | USTRING throughput |
|---|---|---|---|
| win64 | 10.71 ms (178 MB/s) | 16.01 ms | **238 MB/s** |
| win32 | 69.50 ms (27 MB/s) | 21.10 ms | **181 MB/s** |
| linux-x86_64 | 8.37 ms (228 MB/s) | 8.51 ms | **449 MB/s** |

Against `WSTRING` it is a different complexity class, not a tuning difference — a wstring has no length field, so every append walks to the terminator:

| Platform | WSTRING *n* → 2*n* | ratio | USTRING *n* → 2*n* | ratio |
|---|---|---|---|---|
| win64 | 82.45 → 339.56 ms | **4.12** | 0.21 → 0.31 ms | 1.43 |
| linux-x86_64 | 133.37 → 539.68 ms | **4.05** | 0.15 → 0.35 ms | 2.28 |

A ratio near 4 for doubled work is quadratic; near 2 is linear. At 40,000 appends `USTRING` is already **400–900× faster**, and the gap widens.

---

## 📚 Documentation

Everything below is in this repository. There is no documentation website.

| Document | What it covers |
|---|---|
| **[Generics reference](docs/generics/generics.txt)** | Declaration, instantiation, members, operators, generic procedures and inference, inheritance and RTTI, diagnostics, known limits |
| **[`FOR EACH`](docs/for_each/for-each.txt)** | Forms, what can be walked, how it lowers, backward compatibility, diagnostics |
| **[Iterator protocol](docs/for_each/iterator-protocol.txt)** | The RFC-0002 contract, and why the existing `OPERATOR FOR` protocol does not cover collections |
| **Standard library** — [Array](docs/array/array.txt) · [Map](docs/map/map.txt) · [Set](docs/set/set.txt) · [LinkedList](docs/linkedlist/linkedlist.txt) · [Ordered](docs/ordered/ordered.txt) · [Sorting](docs/sort/sort.txt) | Every member, its complexity, and the traps |
| **[`SharedPtr` / `WeakPtr`](docs/sharedptr/sharedptr.txt)** | Every member, the two counts, the cycle rule, `SpCast` and its virtual-destructor contract, thread safety and what it does *not* cover, and why there are two allocations |
| **[`ComPtr` (COM)](docs/comptr/comptr.txt)** | Every member of all four types, the two interface idioms, the `COM_IID` trait and why its tag is a generic marker, the `ComInit`-first ordering rule, what raises and what is unchecked, the cost of copying across an apartment, and the diagnostics |
| **[`#cinclude` / C importer](docs/cimport/cimport.txt)** | Both forms, every `-c*` option, what comes across and what deliberately does not (function-like macros, the A/W macros, `NULL`, `long double`, infinity), the name rules, the cache and its key, the diagnostics, and the known warts — over-alignment, radix, and the size of the output |
| **[String library](docs/string/string.txt)** | All 39 functions, their complexity, the rules that are easy to get wrong, the RFC-4180 CSV pair, and every divergence from AfxNova |
| **[Date/time reference](docs/datetime/datetime.txt)** | Every type and member, the tick model, the `Invalid` rules, exact vs calendar arithmetic, ISO 8601, the pattern language, clocks, zones and interop |
| **[Filesystem reference](docs/filesystem/filesystem.txt)** | Every function and member, the path rules, the error model, the walk semantics, the glob grammar, and the rules that are easy to get wrong |
| **[Goroutines & channels](docs/goroutines/goroutines.txt)** | `spawn`, `Channel( of T )`, `select channel`, `WaitGroup`, `Context`, directional channels — every operation's answer, the traps, and what is deliberately absent |
| **[Tuples](docs/tuples/)** | RFC-0001..0004 plus rationale and a nine-language comparison: the type and its structural identity, the literal, destructuring, equality — and the measurements that changed the design |
| **[`USTRING` reference](docs/ustring/ustring.txt)** | The type, conversions, code units, I/O, the fixed-length form |
| **[Implementation notes](docs/ustring/implementation-notes.md)** | Design decisions **and the mistakes** — several bugs here compiled cleanly and produced plausible output |
| **[Test baseline & gate protocol](docs/tests/tools/BASELINE.md)** | How to reproduce every number on this page |
| **[FreeBASIC manual](https://www.freebasic.net/wiki/DocToc)** | The language itself, unchanged by this project. `src/doc/manual/` is a local mirror of that wiki and is regenerated from it rather than edited here. |
| **Compiler internals** | [The architecture section](#-compiler-architecture) above, and the *How it works* part of the generics reference. |

### Known limitations

Carried deliberately, all measured, none blocking. The full list with reasoning is in [docs/generics/generics.txt](docs/generics/generics.txt); the headline four:

- **No constraints on type parameters.** A member needing `=` on `T` makes the whole type unusable for a `T` without one — which is why `IndexOf`/`Contains` and everything in `fb/sort.bi` are free procedures rather than `Array` members.
- **Generic procedures cannot be overloaded.** One name, one generic procedure: a second one is `error 4` whether it differs in arity, in type-parameter count, or in parameter type. This is why the sort library spells its variants `SortBy`, `StableSort` and `SortList` rather than overloading `Sort`.
- **A *capturing* lambda cannot name the enclosing generic's `T` in its own parameter list** — the closure struct's invoke member is built outside the binding that gives `T` a meaning. Non-capturing lambdas are unaffected, and so is a capturing lambda whose own parameters are concrete.
- **`typeof( T )` does not see through a type parameter**, so a generic body cannot branch on what `T` is bound to. This is why the hash contract is an overloaded `HashOf`.
- **One copy of each instantiation per module.** Costs size, not correctness.
- **`SharedPtr` needs an explicit `SpCast` for derived→base, and the base needs a virtual destructor.** A converting constructor would be a member with its *own* type parameter, which the language does not have; and C++'s trick of type-erasing the deleter at construction needs the address of an instantiated generic procedure, which is not expressible. So the surviving handle destroys through its own `T`. Neither point can be enforced — there are no constraints — so breaking the virtual-destructor contract is silent. `MakeShared` also costs **two allocations**, not C++'s one: fusing them makes the control block generic, and eager member instantiation would then force `T` to be default-constructible for *every* use.
- **`ComPtr`'s `T` is unconstrained, and cannot be.** `ComPtr( of SomePlainUdt )` compiles, instantiates and links; the first `Release` jumps through whatever the first eight bytes of that type happen to be. There are no constraints on type parameters and `typeof( )` does not see through one, so this cannot be checked — it is a contract, and breaking it is silent. **Apartment affinity is also untouched**: a `ComPtr` copied to another thread refcounts perfectly and is still wrong, and the counts balancing is exactly what lets that bug survive testing. A type extending `ComPtr` does not inherit its `->`, which must be redeclared over the derived type.
- **`CONST u AS USTRING`** is not supported — fbc's `CONST` accepts exactly one string type. `WSTRING` is rejected too.
- **No IANA tzdb in the date/time library.** Zones are OS-native only — UTC, the OS local zone, fixed offsets. No named zones, no historical rules, and `AssumeLocal` inside a DST fall-back hour takes the OS's answer. Leap seconds and non-Gregorian calendars are out of scope as well.
- **The filesystem library does not auto-prefix `\\?\`,** so on Windows a path over roughly `MAX_PATH` is refused. The behaviour is correct and diagnosable rather than silently wrong — `FS_NAME_TOO_LONG` with the native code preserved, never a truncation — and a test asserts exactly that. Auto-prefixing changes normalization semantics (`.` and `..` become ordinary names under `\\?\`), so it is not on by default.
- **Tuple element names are documentation only.** `as (min as long, max as long)` parses and is checked for duplicates, then discarded; the fields are `_1.._N`. This follows from structural identity — `(min as long, max as long)` and `(lo as long, hi as long)` are *one* interned symbol, which cannot carry two sets of names. Destructuring is where real names come from: `var (lo, hi) = MinMax( )`. Named access is a pure later addition; the C# model that would allow it is costed in `docs/tuples/rationale.md`.
- **Two tuple *variables* of different element types do not convert.** A tuple **literal** adapts to the type it is stored into, so `dim t as (double, string) = (1, "hi")` and `return (0, "")` work; `dim b as (double, double) = someLongLongTuple` does not. A general tuple-to-tuple conversion was built and reverted — it reached only call arguments, and its result temp could not own anything without double-freeing a `STRING` element. The measurements are in `docs/tuples/RFC-0002-tuple-values.md`.
- **A *nested* tuple literal is not context-typed,** so its elements must already have the target's exact types. `((1, 2), 3)` into `((double, double), long)` works because an integer literal converts at the field; `((1, "x"), 3)` into `((long, string), long)` does not, because a string literal is not a `STRING`. Build the inner tuple first. Lifting it means speculative state on the hottest parse path in the language, for a one-line workaround.
- **`sizeof( (long, string) )` is not spellable,** nor `len` or `typeof` of a tuple type. The parser commits to "this is a type" before parsing and relies on failing without consuming anything, and three tokens of look-ahead cannot tell `( a )` from `( T ptr, U )`. Use a typedef: `type P as (long, string) : print sizeof( P )`.
- **No ordering operators on tuples.** `=` and `<>` only. Lexicographic order is only sometimes what the writer meant, and when it is not the code still compiles and sorts wrong; equality has no such ambiguity. A pure addition if it is ever wanted.
- **`STRING` paths are lossy at the boundary, and silently so.** `STRING` ↔ `USTRING` is UTF-8 both ways on every target, substituting `U+FFFD` for anything invalid — so a legacy ANSI path held in a `STRING` will not open, with no error to catch. Paths that came *from* the filesystem are `USTRING` and should stay that way; the reasoning is in `C:\dev\docs\filesystem\rationale.md`.

---

## 📄 License

tiko-lang is its own compiler, written from scratch in FreeBASIC. It is not a copy of fbc, and it is licensed **in parts**. [LICENSE](LICENSE) is the map, and [decision 0015](docs/architecture/decisions/0015-runtime-independence.md) records why.

| Part | Licence |
|---|---|
| The compiler (`src/`, `tools/`, `build/`, and its own `tests/`) and the `tiko` binaries built from it | **GNU GPL v2 or later** ([COPYING](COPYING)) |
| tiko's documentation (`docs/`, the READMEs, and the ✨ pages in `wiki/`) | **GNU FDL 1.3 or later** |
| The runtime, **tiko-rt** (`lib/rt/`), a derivative of fbc's `libfb` | **GNU LGPL v2.1 or later, with a static-linking exception** ([lib/rt/LICENSE](lib/rt/LICENSE), [COPYING.LGPL-2.1](COPYING.LGPL-2.1)) |
| The graphics library, **libtkogfx** (`lib/gfx/`), a derivative of fbc's `gfxlib2` | **LGPL v2.1 or later, same exception** ([lib/gfx/LICENSE](lib/gfx/LICENSE)) |
| fbc's test suite, vendored in `tests/vendor/` | FreeBASIC's own terms, unmodified; `fbcunit` is LGPL v2.1+ |
| The FreeBASIC manual, reproduced in `wiki/` | **GNU FDL 1.3** ([wiki/License.md](wiki/License.md)) |

**Your programs are yours.** Both libraries extend fbc's static-linking exception to themselves, so a program compiled by tiko and linked against them can be distributed on any terms you choose, just as a program built with fbc can.

**The prebuilt toolchains carry third-party components.** `toolchains/tiko-*/` also redistributes fbc-modern's `inc/` headers. For the `win64` and `linux-x86_64` targets it ships fbc's own runtime binaries under `lib/<target>-fb/`. For `win64` that directory also holds libffi and the MinGW-w64 and gcc runtime libraries. All of it is unmodified. Their notices are in each toolchain's `licences/`. clang is **not** bundled; you install it yourself.

---

<div align="center">

### FreeBASIC did not need replacing. It needed some gaps closed.

The containers in this repository are written in ordinary FreeBASIC, with no compiler privileges of any kind — which means **anything you write is on exactly equal footing**. Better containers, a macOS build, constraints on type parameters, or a bug report with a five-line repro: all of it moves this forward.

**[Open an issue](https://github.com/PaulSquires/tiko-lang/issues) · [Read the generics doc](docs/generics/generics.txt) · [Run the gate](docs/tests/tools/BASELINE.md)**

*Offered for upstream discussion with the FreeBASIC team.*

</div>
