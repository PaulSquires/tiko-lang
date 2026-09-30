[Home](Home) › [C Header Import](Category-C-Header-Import) › **#cinclude Tutorial**

# #cinclude Tutorial

> **In tiko.** tiko imports C headers itself, through libclang loaded at first use, for win64-msvc (the Windows default), win64 and linux-x86_64 (decision 0016, `docs/architecture/decisions/0016-cinclude.md`). It has `-cinclude`, `-cimport`, `-cimport-out`, `-cimport-manifest`, `-cdefine`, `-csysroot`, `-copt`, `-cnomacros`, `-cnoverify`, `-cnocache` and `-ccachedir`; FBC-Modern's `-cprobe`, `-cimport-split`, `-cimport-indir` (with `-cimport-outdir`, `-cimport-recurse`, `-cimport-force` and `-cimport-prefix`) and `-cverbose` are `TKO0100: unknown option` to tiko. Commands written `tiko` below were run with tiko and gave what FBC-Modern's `fbc` gives; those left as `fbc` are FBC-Modern's, and tiko has no equivalent. Measured 2026-09-24 at origin/master 50c71751.

> 📘 **Reference:** [#cinclude](modern-Cinclude)

This is the long way round. If you want the one-paragraph version, it is on the [reference page](modern-Cinclude).

---

## Part 1 — What you already know

To call a C library from FreeBASIC you write a **binding**: a `.bi` full of `Declare`s and `Type`s that restates, in FreeBASIC, what the library's `.h` says in C.

```freebasic
#inclib "sqlite3"

extern "C"
	declare function sqlite3_open cdecl alias "sqlite3_open" _
		( byval filename as const zstring ptr, byval db as any ptr ptr ) as int32
	declare function sqlite3_close cdecl alias "sqlite3_close" _
		( byval db as any ptr ) as int32
end extern
```

This works, and FreeBASIC ships a lot of bindings written exactly this way.

### The problem is that it is a translation

Every line above is a hand-made copy of something that already exists in `sqlite3.h`, and copies drift. Three ways, all of them silent:

**1. A struct is copied wrong.** Say the C is

```c
struct Rec { int id; long long stamp; char name[16]; };
```

and the binding says

```freebasic
type Rec
	id     as int32
	stamp  as int32       '' <-- should be LONGINT
	name   as zstring * 16
end type
```

`stamp` is now 4 bytes where C says 8, so `name` is at the wrong offset and so is everything after it. Nothing warns you. The program reads plausible garbage — a timestamp that is nearly right, a name that is nearly there.

**2. The header changes and the binding does not.** A new SDK adds a field to the middle of a struct. Your binding is now describing last year's memory layout.

**3. The binding is written for one target and used on another.** `int32` is 4 bytes on win64 and 8 on linux-x86_64. `wchar_t` is 2 and 4. A binding that hard-codes either is right on exactly one of them.

### An experiment worth doing

Take any hand-written binding you have and check one struct against the header:

```freebasic
print sizeof( Rec )
```

against

```c
printf( "%zu\n", sizeof(struct Rec) );
```

If they disagree, everything you have ever read through that type was wrong. There is no way to find out other than checking, because nothing in either language is looking.

---

## Part 2 — `#cinclude`, in one line

```freebasic
#cinclude once "sqlite3.h"
#inclib "sqlite3"
```

That is the binding. The header goes to **Clang** — a real C compiler, reading the real header, for the target you are building — and what comes back becomes FreeBASIC declarations.

```freebasic
#cinclude once "sqlite3.h"
#inclib "sqlite3"

dim as sqlite3 ptr db
sqlite3_open( @":memory:", @db )
sqlite3_close( db )
```

Nothing was translated by hand, so nothing can drift.

### It checks itself

This is the part that matters, and it is easy to miss.

The importer does **not** take Clang's word for the layout and write those numbers into the compiler. It emits FreeBASIC **text**, and fbc computes every size, alignment and offset **itself**. So there are two independent answers, and they get compared. If they disagree you get an error naming the record and the first member that differs — at compile time, before your program exists.

That check is not theoretical. `tagVARIANT` from `windows.h` was once imported as 16 bytes where the header says 24, with an entire nested struct missing. It **compiled**. Only the layout comparison caught it.

*(tiko compares the same two answers, but a record that disagrees is refused — left out of the binding, with the difference in the skip ledger — rather than stopping the build; see [the reference](modern-Cinclude#the-layout-is-checked-not-trusted).)*

---

## Part 3 — Tutorial: SQLite, end to end

*The commands below are tiko's, measured 2026-09-24 at origin/master 50c71751 with SQLite's own `sqlite3.h` in `vendor/`, except in Steps 6 and 7, which are FBC-Modern's. `#inclib "sqlite3"` needs a library the linker can use: on tiko's default target, win64-msvc, an import library (`libsqlite3.dll.a`) links, but a MinGW-built static `libsqlite3.a` does not (`lld-link: error: undefined symbol: ___chkstk_ms`); `-target win64` links the static one.*

### Step 1 — check the path works

```
tiko --cimport-probe stddef.h
```

If that prints the libclang it loaded, clang's version and target, and the headers clang read, you are ready. If not, it says what it tried: install LLVM — libclang 16 or newer, and the clang 18 or newer every tiko build needs ships one — or set `TKO_LIBCLANG` to the library. `--cimport-probe` is a compiler-development option; FBC-Modern's `fbc -cprobe stddef.h` prints a census instead, and tiko has no `-cprobe`.

> libclang is loaded on first use through [`DyLibLoad`](Dylibload). It is never linked. tiko builds and runs without it — you only need it if you actually import a header.

### Step 2 — get the header where Clang can see it

If SQLite is installed system-wide, `#cinclude once "sqlite3.h"` just works.

If you are vendoring it — shipping the header inside your own tree — put it somewhere and name the directory on the command line:

```
myapp/
    app.tiko
    vendor/sqlite3.h
```

```
tiko app.tiko -cinclude vendor
```

`-cinclude` is passed to Clang as `-I`.

You can also name the folder in the directive itself and drop the flag:

```freebasic
#cinclude once "vendor/sqlite3.h"
```

```
tiko app.tiko
```

That is what FBC-Modern's shipped SQLite example does — but it works only while tiko is run **from the directory containing `vendor/`**. Build it from elsewhere and you are back to `-cinclude`, because the path is resolved against the working directory, not against the file that wrote it.

> ⚠️ `#cinclude` resolves the header against the **compiler's working directory** and the `-cinclude` directories — **not** against the file that contains the directive. This is unlike [`#foreignlib`](modern-Foreignlib), and it is a known wart; see [Part 5](#part-5--using-it-with-foreignlib).

### Step 3 — write the program

```freebasic
#cinclude once "sqlite3.h"
#inclib "sqlite3"

dim as sqlite3 ptr db

if( sqlite3_open( @":memory:", @db ) <> SQLITE_OK ) then
	print "open failed: "; *sqlite3_errmsg( db )
	end 1
end if

dim as zstring ptr errmsg
sqlite3_exec( db, @"create table part( name text, qty integer );", 0, 0, @errmsg )
sqlite3_exec( db, @"insert into part values('bolt', 40);", 0, 0, @errmsg )

sqlite3_close( db )
print "ok"
```

`sqlite3`, `sqlite3_open`, `SQLITE_OK`, `sqlite3_errmsg` — none of them declared here. `sqlite3` itself is an **opaque handle** in C (`typedef struct sqlite3 sqlite3;`, never defined), and it arrives as `type sqlite3 as any`, which is the opaque pointer C intended.

### Step 4 — hand C a FreeBASIC function

This is the part a hand-written binding gets wrong most often, because the callback's calling convention and parameter widths have to match exactly and nothing checks them.

`sqlite3_exec` takes `int (*)(void*, int, char**, char**)`. The importer turned that into a FreeBASIC procedure-pointer type with that exact shape, so the compiler will now check your function against it:

```freebasic
function OnRow ( byval user as any ptr, byval ncols as int32, _
                       byval values as zstring ptr ptr, _
                       byval names as zstring ptr ptr ) as int32
	dim as int32 ptr count = user
	*count += 1
	print *names[0]; " = "; *values[0]
	return 0                     '' 0 keeps going; anything else aborts
end function

dim as int32 rows
sqlite3_exec( db, @"select name, qty from part;", @OnRow, @rows, @errmsg )
print rows; " rows"
```

### Step 5 — look at what you got

```
tiko -cimport sqlite3.h -cimport-out sqlite3_generated.ti -cinclude vendor
```

writes the binding to a file instead of including it. Open it. At the top is a banner recording the headers, the target, the Clang version and the census, then two **ledgers**: every name that had to be changed, with the reason, and every declaration that was skipped, with the reason. Nothing is dropped in silence.

The output is **deterministic** — same headers, same options, byte-identical file, on either operating system — so you can check it in and `diff` it across an SDK upgrade to see exactly what changed. (With tiko two runs gave byte-identical files on Windows, measured 2026-09-24 at origin/master 50c71751; across operating systems is not measured.)

### Step 6 — split it up, if you are going to read it

*FBC-Modern's `fbc` only — tiko has no `-cimport-split` (`TKO0100`) and no equivalent.*

A single file for `windows.h` is 2.8 MB. `-cimport-split` writes the same declarations as one file per C header, with an index that ties them together:

```
fbc -cimport windows.h -cimport-out win.bi -cimport-split bindings
```

147 parts, and `bindings\win.bi` to `#include`. The parts are fragments — the index carries the banner, the `extern` block and the forward aliases — so include the index, not a part.

You will notice a few headers appear twice, numbered. That is not a bug: a C header's declarations straddle its own `#include`s, so `winnt.h` has declarations both before and after the `ktmtypes.h` it includes. Each part is one contiguous run, which is what makes the order still correct.

### Step 7 — or convert a whole directory, if you are porting

The steps above give you a binding to **use**. If instead you are **porting** a
library — you want the shape of its whole header tree in FreeBASIC and you
expect to finish it by hand — FBC-Modern's `fbc` has a mode for that (tiko has none of `-cimport-indir`, `-cimport-outdir`, `-cimport-recurse`, `-cimport-prefix`: each is `TKO0100`):

```
fbc -cimport-indir vendor -cimport-outdir bi -cimport-recurse
```

One `.bi` per `.h`, folders mirrored, each file carrying only its own header's
declarations and `#include once` lines mirroring the C ones.

Two things to be clear about before you use it. **Nothing is verified** — the
layout check needs fbc to lay the record out, and these files are never
compiled. And **what did not convert is left in place**, commented out, behind
one tag:

```freebasic
'' >>> CIMPORT-TODO: function 'lensq' -- static: internal linkage, so there is no symbol to link against
''     static __inline int lensq(struct Line l)
```

Search `CIMPORT-TODO` and you have your to-do list, in the order the header
declared things. That is the whole point of the mode: not a binding, a map of
the work.

A header that does not parse as C on its own is **not** converted — it gets a
`.bi` saying so. That is about 670 of the 1,668 mingw headers, most of which
assume `windows.h` has been seen. `-cimport-prefix windows.h` parses a header
in front of each one and converts most of them, but costs 4–5 headers a minute
against 1,668 in 9.5 minutes without, so it suits a subdirectory rather than
the whole tree.

---

## Part 4 — The things that will surprise you

### Function-like macros are not imported

```c
#define MAKEINTRESOURCE(i) ((LPWSTR)((ULONG_PTR)((WORD)(i))))
#define IDC_ARROW          MAKEINTRESOURCE(32512)
```

Neither of those comes across. A macro body is an arbitrary token sequence with C's semantics — casts, the comma operator, `sizeof`, token pasting — and translating one means writing a C expression compiler. There is no safe partial version: a macro that translates to *nearly* the right expression is worse than one that does not translate at all.

Write the expansion:

```freebasic
LoadCursorW( 0, cast( LPCWSTR, cast( ULONG_PTR, 32512 ) ) )
```

**Object-like** macros — `#define MAX_PATH 260`, every `WM_*`, every `SQLITE_*` — do come across, folded by Clang in the real header context.

### The A/W names come across, and `#define UNICODE` picks

`GetMessage`, `RegisterClassEx` and `CreateWindowEx` are macros standing for another name, and about 1,100 of them are imported as FreeBASIC `#define`s — so unsuffixed Win32 code works as written.

Which variant you get follows the FreeBASIC side, the way the shipped `windows.bi` has always worked:

```freebasic
#define UNICODE
#cinclude once "windows.h"     '' GetMessage -> GetMessageW
```

Leave the `#define` out and you get the ANSI API, exactly as C does. Both suffixed names are always present either way.

### You do not have to write a calling convention

An imported function pointer says whatever the header says for this target — often `cdecl`, because `WINAPI` and friends are defined away on win64. FreeBASIC's own default there is `stdcall`. On a 64-bit target those are the same call, and fbc treats `cdecl`, `stdcall` and `stdcall_ms` as interchangeable, so a plain

```freebasic
function MyCallback( byval a as int32 ) as int32
```

matches an imported `cdecl` pointer with no warning and no cast.

`pascal` is the exception, and should be: it reverses the argument order, so it stays incompatible and still warns.

*(In tiko: the assignment draws `TKO0830`, tiko's form of that warning, and the call through it with `(1, 2)` gets `21`, as FBC-Modern's build does. Measured 2026-09-25; before, it had no warning and got `12`.)*

### `NULL` is not there

FreeBASIC's own crt headers define it, so emitting it too would be a duplicate definition. Write `0`.

### Names occasionally change, and the file says so

FreeBASIC is case-insensitive and has words of its own. C's `time()` collides with the [`Time`](Time) statement and becomes `time_`; `size_t` and `SIZE_T` are one name, so the second becomes `SIZE_T_2`.

Much less renaming happens than you would expect, though — `POINT`, `INPUT`, `COLOR` and `DIR` all keep their names as **types**, and a type and a procedure may share a name, so `INITCOMMONCONTROLSEX` and `InitCommonControlsEx` coexist. Every change is in the ledger with its reason, and every declaration carries `alias "<exact C name>"`, so the linker never sees a renamed symbol.

### The first import of a big header is slow

`windows.h` is about fifteen seconds cold and roughly 35,000 declarations. It is **cached** after that, keyed on the headers, the options, the target, the Clang version and the fbc build — so the expensive half runs once per configuration and the cheap half runs per compilation, exactly as `#include` does.

`-cverbose` tells you what happened, including **why** the cache missed.

With tiko, measured 2026-09-24 at origin/master 50c71751: a program that `#cinclude`s `windows.h` built in 18.7 s cold and 0.6 s warm on win64-msvc, about 43,000 declarations. Its cache key has the running `tiko` in place of the fbc build. tiko has no `-cverbose`; `-cnocache` bypasses the cache and `-ccachedir` moves it.

---

## Part 5 — Using it with `#foreignlib`

Binding to a C library is two jobs, and there is a directive for each:

| | answers | |
| --- | --- | --- |
| [`#cinclude`](modern-Cinclude) | *what are these things?* | the **header** half |
| [`#foreignlib`](modern-Foreignlib) | *where is the code?* | the **linkage** half |

Neither implies the other. `#cinclude` declares everything and links nothing; `#foreignlib` links a library and declares nothing.

If the library is installed on the system, `#inclib` is all you need:

```freebasic
#cinclude once "sqlite3.h"
#inclib "sqlite3"
```

If you are shipping the library **inside your own source tree**, `#foreignlib` resolves it relative to the declaring file and picks the per-target filename for you:

```
mylib/
    mylib.ti
    vendor/mylib.h
    vendor/mylib_windows_x86_64.dll.a
    vendor/mylib_linux_x86_64.so
```

```freebasic
'' mylib/mylib.ti
#pragma once

#cinclude once "mylib.h"
#foreignlib MYLIB dynamic "vendor/mylib"
```

and the using code needs neither a `Declare` nor an `#ifdef`:

```freebasic
#include once "mylib/mylib.ti"
print mylib_add( 2, 3 )
```

### The wart

The two do **not** resolve paths the same way, and you will hit this.

`#foreignlib` resolves its library relative to **the file containing the directive** — that is [the entire reason it exists](modern-Foreignlib), because `#libpath` is relative to the working directory and therefore unusable in a shipped binding.

`#cinclude` does not do this. Clang resolves the header, against the working directory plus the `-cinclude` directories. So `mylib.ti` above still cannot say where its own header is; the build has to:

```
tiko app.tiko -cinclude mylib/vendor
```

It is the same trap `#foreignlib` was written to close, still open on the header side. Until that changes, a vendored binding has to state the include directory it needs somewhere outside the `.ti` — a README, a makefile, a build script.

---

## Part 6 — Worked examples in the repository

They are in FBC-Modern's repository, not tiko-lang's, and both check their own results. Copied out and built with tiko, measured 2026-09-24 at origin/master 50c71751, `winapi_window.bas` prints `winapi ok -- the window manager called into FreeBASIC 3 times` on win64-msvc and win64, and `sqlite_query.bas` prints `sqlite ok -- 3.53.4, 3 rows through a FreeBASIC callback, 2 through a statement` with `-target win64` — the lines FBC-Modern's `fbc` builds print. On win64-msvc `sqlite_query.bas` does not link: its vendored `sqlite3_windows_x86_64.a` is a MinGW archive (`lld-link: error: undefined symbol: ___chkstk_ms`, `TKO0116`).

| | |
| --- | --- |
| `examples/cimport/winapi_window.bas` | A real window from `windows.h`, with a `WNDPROC` the **window manager** calls back into FreeBASIC. Closes itself, so it runs unattended. |
| `examples/cimport/sqlite_query.bas` | SQLite: opens a database, runs statements, and passes a FreeBASIC function to `sqlite3_exec` as a row callback. Header vendored in `examples/cimport/vendor`. |

The WinAPI one is worth reading for what it does **not** say. Its `WndProc` carries no calling convention at all — just `function WndProc( byval hwnd as HWND, ... )`, the way every Win32 programmer has always written it — and that is not an oversight.

`windows.h` declares `WNDPROC` as `WINAPI`, which every tutorial ever written will tell you is `__stdcall`. On win64 it is neither: x86-64 Windows has one calling convention, the SDK defines `WINAPI` away, and Clang reports the default — so the imported typedef reads `cdecl`, while FreeBASIC's own default on win64 is `stdcall`. Two different words for the same call.

fbc treats `cdecl`, `stdcall` and `stdcall_ms` as interchangeable on a 64-bit target for exactly that reason, so all three spellings assign cleanly. `pascal` is deliberately not in that set and still warns: it reverses the argument order, on x86-64 as anywhere else, so calling a `pascal` procedure through a `cdecl` pointer with `(1, 2)` really does hand you `21`, with FBC-Modern's `fbc` and with tiko alike, and both warn (tiko's is `TKO0830`; see [Part 4](#you-do-not-have-to-write-a-calling-convention)).

### See also

- [#cinclude](modern-Cinclude) — the reference
- [`#foreignlib`](modern-Foreignlib) · [#foreignlib Tutorial](modern-Foreignlib-tutorial)
- [`#inclib`](Inclib) · [`#include`](Include)
- [`Alias`](Alias-Modifier) · [`Declare`](Declare) · [`Extern`](Extern)

---

**Category:** [C Header Import](Category-C-Header-Import)
**Kind:** tutorial
**Source:** `docs/cimport/cimport.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

---

[Home](Home) · [Keyword Index](Keyword-Index)
