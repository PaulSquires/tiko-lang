[Home](Home) › [All Categories](Categories) › **C Header Import**

# C Header Import

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

> 📘 **Also in this category:** [#cinclude Tutorial](modern-Cinclude-tutorial) ✨


## Syntax

```freebasic
#cinclude [once] "header.h"
```

## Description

Uses a C library's **own header** in place of a hand-written FreeBASIC binding.

The header is handed to **Clang**, and what comes back is converted into FreeBASIC declarations for the target being built — structs, unions, enums, typedefs, functions, function pointers, globals and object-like macros — which are then included at the point of the directive.

```freebasic
#cinclude once "sqlite3.h"
#foreignlib SQLITE static "vendor/sqlite3"

dim as sqlite3 ptr db
sqlite3_open( @":memory:", @db )
```

That is the whole binding. No `.bi` file, no `Declare`, no struct copied out by hand.

`once` means what it means for [`#include`](Include).

## Parameters

| | |
| --- | --- |
| `once` | Optional. Include the generated binding only the first time it is reached |
| `"header.h"` | The header, as you would spell it in C. Resolved by **Clang**, not by fbc — fbc's own include search is the wrong one for C headers |

## The layout is checked, not trusted

The importer does **not** write Clang's offsets into the compiler's symbols. It emits FreeBASIC **text** and lets fbc compute every size, alignment and member offset itself, so there are two independent answers to compare. A disagreement is a compile-time error naming the record and the first member that differs:

```
error 389: C ABI mismatch in imported header -- this is a bug in the C importer,
please report it with the generated binding, 'MemberAligned': clang reports size
12, align 4; FreeBASIC computed size 8, align 4; first differing member: 'd' at
bit 32 (clang) vs bit 8 (FreeBASIC)
```

That check has already earned its keep: `tagVARIANT` was once imported as 16 bytes where `windows.h` says 24, with an entire nested struct missing — and it **compiled**. Nothing but the layout comparison would have caught it.

`-cnoverify` turns the check off. There is no good reason to use it.

## Requirements

Clang **16 or newer**, wherever fbc already looks for it — the same place [`-gen llvm`](Compiler-Option-Gen) looks. libclang is loaded on first use through [`DyLibLoad`](Dylibload); it is never linked, so fbc builds and runs without Clang and only an actual import needs it.

Targets: **win64** and **linux-x86_64**.

```
fbc -cprobe stddef.h
```

reports whether the whole path works, and exits.

## The command-line form

```
fbc -cimport windows.h -cimport-out windows_generated.bi
```

generates the binding as a **file** instead of including it — for reading, for checking into a repository, or for diffing across an SDK upgrade. The output is deterministic: the same headers and options give a byte-identical file on either operating system, so a diff means something changed in the header.

Several headers in one command share one binding, and shared types are declared exactly once:

```
fbc -cimport windows.h -cimport commctrl.h -cimport-out win.bi
```

### One file per header: `-cimport-split`

A single 2.8 MB `.bi` is correct but not pleasant to read or to diff. `-cimport-split <dir>` writes the same declarations as **one file per C header**, plus an index named after `-cimport-out`:

```
fbc -cimport windows.h -cimport-out win.bi -cimport-split bindings
```

gives 147 parts and `bindings\win.bi` — 2,885,668 bytes in total against 2,860,389 for the single file. The difference is the per-part banners, **not** duplicated declarations, which is what makes this different from importing each header separately: done that way each `.bi` re-emits `windows.h` and comes to 2.8 MB *on its own*.

**Include the index.** The parts are fragments: the index carries the banner, `crt/long.bi`, the `extern "C"` block and the forward pointer aliases, and each part carries only declarations and says so at the top.

> **A header can produce more than one part, and that is not a defect.** A C header's declarations straddle its own `#include`s — `winnt.h` includes `ktmtypes.h` partway through, so `winnt.h`'s own declarations sit both before *and* after `ktmtypes.h`'s. One file per header would force `winnt.bi` into a single position and half its dependencies would land on the wrong side; the first version of this produced a `ktmtypes.bi` that used `PVOID` and `ULONG` before `winnt.bi` declared them, and ordering whole files by their last declaration fixed `stdio.h` while still failing `windows.h`.
>
> So a part is one **contiguous run** of declarations from one header, numbered when a header contributes several. The parts in order *are* the single file, so the index is correct by construction rather than by a dependency analysis that C headers do not admit.


### A whole directory at once: `-cimport-indir`

```
fbc -cimport-indir <dir> -cimport-outdir <dir> [-cimport-recurse]
```

One `.bi` per `.h`, mirroring the folder structure — `in/sys/stat.h` becomes `out/sys/stat.bi`.

**This is a different contract from the modes above, and the difference is the point.** `-cimport-out` and `-cimport-split` produce *one* translation unit: every type declared once, every record's layout checked against fbc's own, a binding you can use. `-cimport-indir` produces a **mechanical, file-for-file translation** — a starting point for hand-porting.

Each `.bi` carries **only what its own header declares**. The declarations of the headers it `#include`s belong to *their* `.bi` files, and are reached through include lines mirroring the C ones:

```freebasic
'' out/sub/extra.bi
#include once "../base.bi"
```

written **relative to the file that contains them**, because that is how FreeBASIC resolves `#include`.

> ⚠️ **Nothing here is verified.** The layout check needs fbc to lay the record out, and these are text files that nothing compiles. That is the trade: you get the shape of the whole tree at once and you give up the guarantee. When you want a binding to *use* rather than to *port*, use `-cimport-out`.

**What did not convert is left in place**, not dropped. The other modes skip such declarations and summarise them in a ledger at the top of the file; here the note sits where the declaration stood, quotes the C it came from, and carries one greppable tag:

```freebasic
'' >>> CIMPORT-TODO: function 'lensq' -- static: internal linkage, so there is no symbol to link against
''     static __inline int lensq(struct Line l)
```

Search for `CIMPORT-TODO`. This also catches what the other modes only **count**: a `static` or `inline` function never claims a name, so `-cimport-out` tallies it in the banner and says no more — which is no help when you are reading one file and wondering where a function went. On `winnt.h` + `winuser.h` it marks 291 items, 11 of them inline functions that were otherwise invisible.

| | |
| --- | --- |
| `-cimport-recurse` | walk subfolders, mirroring them in the output |
| `-cimport-force` | reconvert headers that already have a `.bi` |
| `-cimport-prefix <hdr>` | parse `<hdr>` before each header — see below |

Without `-cimport-force` an existing `.bi` is left alone, so a long run can be stopped and restarted.

#### A header that does not parse is not converted — and says so

About **670 of the 1,668** mingw headers do not compile as C on their own. `winnt.h`, `shellapi.h` and most of the rest assume `windows.h` has already been seen; a few (`ddk/fltsafe.h`) are C++ outright.

Each still gets a `.bi`, carrying a marker that names the reason:

```freebasic
'' >>> CIMPORT-TODO: header 'fltsafe.h' -- this header does not compile as C on its own (5 clang error(s)); it may be C++, or need another header included before it
```

so the mirrored tree has no holes you have to interpret. (Refusing them is also what stops the compiler crashing: Clang is asked to keep going, so a broken header still yields a **partial** tree, and walking one used to segfault 1,529 files into a conversion of the Windows headers.)

#### `-cimport-prefix` raises the yield, at a price

```
fbc -cimport-indir vendor -cimport-outdir bi -cimport-prefix windows.h
```

The prefix is parsed **before each header** and contributes nothing to the output — declarations are attributed to the file that wrote them — so it only supplies the types the header was written to assume. That converts most of the 670.

> ⚠️ **It is expensive**, and the numbers are worth having before you start. Measured on the mingw tree:
>
> | | |
> |---|---|
> | no prefix | 1,668 headers in **9.5 minutes** |
> | `-cimport-prefix windows.h` | **4–5 headers a minute** |
>
> Every parse re-reads the prefix, and the binding cache does not apply in this mode. For the whole tree that is hours rather than minutes — so it is worth it for a subdirectory or a third-party library, and not for everything.

## Options

| option | |
| --- | --- |
| `-cinclude <dir>` | A C include directory. Passed to Clang as `-I` |
| `-cdefine <name>[=<value>]` | A C macro. Passed as `-D` |
| `-csysroot <dir>` | The C sysroot |
| `-copt <arg>` | Passed to Clang verbatim |
| `-cnomacros` | Do not import object-like macros as constants |
| `-cnoverify` | Skip the layout check |
| `-cimport-split <dir>` | Write one `.bi` per C header into `<dir>`, plus an index — see below |
| `-cimport-indir <dir>` | Convert every `.h` in a directory to a `.bi` — see below |
| `-cimport-outdir <dir>` | Where `-cimport-indir` writes them |
| `-cimport-recurse` | Walk subfolders of `-cimport-indir`, mirroring them |
| `-cimport-force` | Reconvert headers that already have a `.bi` |
| `-cimport-manifest <f>` | Write the ABI manifest to a file |
| `-ccachedir <dir>` | Where bindings are cached |
| `-cnocache` | Always re-import |
| `-cverbose` | Report the census, the verify result, and **why** the cache missed |
| `-cprobe <header>` | Report what a header contains, and exit |

The first four are part of the **cache key**, so the same header imported with different options gives different entries and they cannot be confused for one another.

## What comes across

| | |
| --- | --- |
| structs, unions | layout verified, bit-fields included, anonymous members flattened or nested as FreeBASIC requires |
| enums | as `type Color as ulong` plus a plain `Enum` block — never as a FreeBASIC `Enum`, which is 8 bytes where C says 4 |
| typedefs | kept by name, so `LPCWSTR` stays `LPCWSTR` |
| functions | including variadics, and the calling convention the header states **for the target being built** — see [Calling conventions](#calling-conventions) |
| function pointers | with their real signatures, so a callback handed to C is type-checked |
| globals | as `Extern`, with an `Alias` |
| object-like macros | `#define MAX_PATH 260`, folded by Clang in the real header context |

An opaque handle — `typedef struct sqlite3 sqlite3;` with no definition — becomes `type sqlite3 as any`, which is the opaque pointer C intended.

## The A/W names, and `#define UNICODE`

About 1,100 Windows names are not functions but **macros standing for another name**:

```c
#define GetMessage  __MINGW_NAME_AW(GetMessage)
#define WNDCLASSEX  __MINGW_NAME_AW(WNDCLASSEX)
```

They are object-like, so they are candidates, but they do not fold to a constant. They are imported as FreeBASIC `#define`s instead —

```freebasic
#define GetMessage GetMessageW
```

— so unsuffixed Win32 code works as written, with nothing to rewrite.

**Which one you get is decided on the FreeBASIC side**, exactly as it is with the shipped `windows.bi`:

```freebasic
#define UNICODE
#cinclude once "windows.h"     '' GetMessage -> GetMessageW
```

```freebasic
#cinclude once "windows.h"     '' GetMessage -> GetMessageA
```

Nothing is imposed, and there is one rule to remember rather than two. From the `-cimport` driver, where there is no FreeBASIC source to carry a `#define`, use `-cdefine UNICODE`.

The **suffixed** names are imported either way — `GetMessageA` and `GetMessageW` are real functions and always present. The define decides only what the unsuffixed name means.

So this compiles, with no suffix and no calling convention anywhere:

```freebasic
#define UNICODE
#cinclude once "windows.h"

function WndProc ( byval h as HWND, byval m as UINT, _
                   byval wp as WPARAM, byval lp as LPARAM ) as LRESULT
	return DefWindowProc( h, m, wp, lp )
end function

dim as WNDCLASSEX wc
wc.cbSize      = sizeof( WNDCLASSEX )
wc.lpfnWndProc = @WndProc
wc.hInstance   = GetModuleHandle( 0 )
RegisterClassEx( @wc )
```

> **Two aliases cannot share a name.** `commdlg.h` has a struct `CHOOSECOLOR` *and* a function `ChooseColor`, and gives each an A/W macro. To C those are two names; to FreeBASIC, whose `#define` is case-insensitive, they are one. Emitting both is a duplicate definition, and emitting only the first is worse — a `#define` rewrites tokens before the parser sees them, so the loser's every use would silently expand to the winner's target. Both are dropped and the skip ledger says so; the suffixed names still work.
>
> A related consequence: a name **you** have `#define`d is rewritten wherever it appears, a field declaration included. `windows.h` has a field literally named `Unicode` (in `_FPO_DATA`), so importing with `UNICODE` defined renames it to `Unicode_` — which is exactly what FreeBASIC's own hand-written binding does at `inc/win/winnt.bi`.

## Calling conventions

An imported procedure or function pointer carries whatever convention the header states **for the target being built**, which is not always what the documentation says. `windows.h` declares `WNDPROC` as `WINAPI`; on win64 the SDK defines `WINAPI` away, because x86-64 Windows has exactly one calling convention, so Clang reports the default and the imported typedef reads `cdecl`.

FreeBASIC's own default on win64 is `stdcall`. Both describe the same call.

**fbc treats `cdecl`, `stdcall` and `stdcall_ms` as interchangeable on a 64-bit target**, so you do not have to write one to match an imported pointer:

```freebasic
'' all three assign cleanly to an imported `cdecl` procedure pointer
function A cdecl   ( byval x as long ) as long : return x : end function
function B stdcall ( byval x as long ) as long : return x : end function
function C         ( byval x as long ) as long : return x : end function
```

`pascal` is **not** in that set and still warns. It is not a mangling or a register difference — it reverses the argument order, on x86-64 as anywhere else, so a `pascal` procedure called through a `cdecl` pointer with `(1, 2)` returns `21`.

> Stock FreeBASIC warns on the `cdecl`/`stdcall` mismatch even on x86-64, deliberately, so that code stays portable to x86 where the distinction is real. tiko-lang has dropped 32-bit, so that protection has nothing left to protect and only its cost remained — every Win32 callback written the ordinary way warned against an imported header, with no spelling that silenced it.

## What does not

- **Function-like macros.** `#define MAKEINTRESOURCE(i) ((LPWSTR)((ULONG_PTR)(i)))` is an arbitrary token sequence with C's semantics, and translating one means writing a C expression compiler. There is no safe partial version: a macro that translates to *nearly* the right expression is worse than one that does not translate at all. Write the expansion yourself.
- **`NULL`.** Dropped deliberately — FreeBASIC's own crt headers define it, and emitting it too would be a duplicate definition. Write `0`.
- **C++.** C headers only.
- **`long double`**, and **infinity/NaN** as constant values. FreeBASIC has no spelling for either; both are skipped, with the reason in the ledger.

## Working with `#foreignlib`

Binding to a C library is **two** jobs, and these are the two halves:

| | what it answers | |
| --- | --- | --- |
| [`#cinclude`](modern-Cinclude) ✨ | *what are these things?* — the types, the signatures, the constants | the **header** half |
| [`#foreignlib`](modern-Foreignlib) ✨ | *where is the code?* — which file to link, for this target | the **linkage** half |

Neither implies the other. `#cinclude` declares everything and links nothing; `#foreignlib` links a library and declares nothing. Used together they let a binding ship **entirely inside your own source tree**, with no system-installed header and no system-installed library:

```
mylib/
    mylib.bi                        <- the binding: both directives
    vendor/mylib.h                  <- the library's own header
    vendor/mylib_windows_x86_64.dll.a
    vendor/mylib_linux_x86_64.so
```

```freebasic
'' mylib/mylib.bi
#pragma once

#cinclude once "mylib.h"            '' the declarations, from the real header
#foreignlib MYLIB dynamic "vendor/mylib"   '' the library, per target
```

and then, with no `Declare` and no `#ifdef` anywhere:

```freebasic
#include once "mylib/mylib.bi"
print mylib_add( 2, 3 )
```

The declarations come out of the header for the target being built, and the right library file is chosen for that same target. A cross-platform binding stops being a maintenance problem in two directions at once.

> ⚠️ **They do not resolve paths the same way, and this is a wart.**
>
> `#foreignlib` resolves its library **relative to the file containing the directive** — that is [the whole reason it exists](modern-Foreignlib), because `#libpath` is relative to the compiler's working directory and therefore unusable in a shipped binding.
>
> `#cinclude` does **not** do this. The header is resolved by **Clang**, against Clang's own include search: the compiler's working directory plus any `-cinclude` directories. So in the layout above, `#cinclude once "mylib.h"` needs
>
> ```
> fbc app.bas -cinclude mylib/vendor
> ```
>
> and a bare `#cinclude "vendor/mylib.h"` inside `mylib.bi` resolves against wherever the user happened to stand, not against `mylib.bi`. It is the same trap `#foreignlib` was built to close, still open on the header side.
>
> Until that changes, a vendored binding has to say which include directory it needs — in its README, or in a `Makefile`. There is no spelling inside the `.bi` that works from every working directory.

There is **no `lib MYLIB` clause**, and there cannot be — the declarations are generated rather than written. It is not needed: a `#foreignlib` contributes its libraries to the link whether or not any declaration names it, exactly as [`#inclib`](Inclib) does. The bound name exists for hand-written declarations that want it.

If the library is installed on the system rather than vendored, [`#inclib`](Inclib) is simpler and `#foreignlib` buys you nothing:

```freebasic
#cinclude once "sqlite3.h"
#inclib "sqlite3"
```

### `system:` does not give you a dynamic link

`#foreignlib` can spell the same thing with a `system:` spec, and it is tempting to read the mandatory `dynamic` as a guarantee that you will not silently get a static archive:

```freebasic
#foreignlib SQLITE dynamic "system:sqlite3"    '' does NOT guarantee anything
```

It is not a guarantee. `fbForeignLibResolve( )` returns as soon as it sees a `system:` spec:

```freebasic
'' "system:name" -- hand the bare name to the linker, resolve nothing
if( lcase( left( spec, 7 ) ) = "system:" ) then
	linkname = mid( spec, 8 )
	function = (len( linkname ) > 0)
	exit function
end if
```

`isstatic` is never consulted. The directive emits `-lsqlite3`, exactly as [`#inclib`](Inclib) does, and the linker takes whatever it finds first.

Verified rather than assumed: with only a static `libsqlite3.a` present and no import library, the line above **links, and links statically** — no `sqlite3.dll` in the resulting import table, and no diagnostic. It said `dynamic` and did the opposite.

So for this purpose `system:` is *worse* than `#inclib`: identical behaviour, but it reads like an assurance. The `static`/`dynamic` keyword is meaningful only for a **file** spec, where it constrains which extensions are eligible and a file of the other kind is an error.

> If you need a genuinely guaranteed dynamic link, neither directive gives you one today. The mechanism exists in GNU `ld` — `-Bdynamic` / `-Bstatic` — but it is **positional** (passing it through `-Wl` lands it after the `-l` it was meant to constrain, where it does nothing) and **sticky** (it also changes resolution for every following library, the C runtime included). Honouring it would mean bracketing the one `-l` and restoring the previous mode, and it is `ld`-specific.

## Names

The C name is kept wherever FreeBASIC allows it, and every change is recorded in a ledger at the top of the generated file, with its reason.

- A **quirk word may name a type.** `POINT`, `INPUT`, `IMAGE`, `COLOR` and `DIR` are procedures fbc already has, so they cannot name a procedure — but `type POINT as tagPOINT` is legal, and `POINT` stays `POINT`.
- A **type and a procedure may share a name.** `INITCOMMONCONTROLSEX` the struct and `InitCommonControlsEx` the function coexist, as do POSIX's `struct stat` and `stat()`.
- What genuinely collides gets a suffix: `size_t` and `SIZE_T` are one name to FreeBASIC, so the second becomes `SIZE_T_2`. C's `time()` collides with the [`Time`](Time) statement and becomes `time_`.

Every declaration carries `alias "<exact C name>"`, so a rename never changes the symbol the linker sees. Constants are the exception — a `Const` is a compile-time value, not a symbol.

## Remarks

- The generated binding is **cached**, so the expensive half runs once per configuration and the cheap half — parsing FreeBASIC text — runs per compilation, exactly as [`#include`](Include) does today. The key covers the importer's schema, the fbc version and build, the dialect, the target, the Clang version, the headers and the option vector; the entry also records every file Clang read, so editing any header in the tree invalidates it.
- `windows.h` is about **35,000 declarations**, of which 2,517 are records, all verified.
- Over-alignment (`__declspec(align(16))`) has no FreeBASIC spelling. C's tail padding is written out so `SizeOf` and every member offset are right, and the affected records are reported by name — but a local or array element is 8-byte aligned where C promises 16.
- New to tiko-lang. Not present in FreeBASIC.

### See also

- [#cinclude Tutorial](modern-Cinclude-tutorial) ✨ — start here
- [`#foreignlib`](modern-Foreignlib) ✨ — linking a library shipped inside your own source tree, the other half of binding to a C library
- [`#include`](Include) · [`#inclib`](Inclib) · [`#libpath`](Libpath)
- [`Alias`](Alias-Modifier) · [`Extern`](Extern) · [`Declare`](Declare)
- [`DyLibLoad`](Dylibload) — how libclang is loaded
- [Compiler Option: -gen](Compiler-Option-Gen)

## Examples

```freebasic
'' A real window from windows.h, with no binding file. The WINDOW MANAGER
'' calls WndProc -- so the convention, the widths and the return type all
'' come from the C header, and nothing here restates them.

#cinclude once "windows.h"

function WndProc ( byval hwnd as HWND, byval msg as UINT, _
                   byval wp as WPARAM, byval lp as LPARAM ) as LRESULT
	if( msg = WM_DESTROY ) then
		PostQuitMessage( 0 )
		return 0
	end if
	return DefWindowProcW( hwnd, msg, wp, lp )
end function
```

> **No calling convention, and none is needed.** `windows.h` declares `WNDPROC` as `WINAPI`, the SDK defines `WINAPI` away on win64 — x86-64 Windows has one calling convention — so the imported typedef reads `cdecl`, while FreeBASIC's own default on win64 is `stdcall`. Those describe the same call, and fbc treats `cdecl`, `stdcall` and `stdcall_ms` as interchangeable on a 64-bit target, so this assigns cleanly whether you write `cdecl`, `stdcall`, or nothing at all. `pascal` is excluded and still warns — it reverses the argument order, on x86-64 as anywhere else.

```freebasic
'' A third-party library, header and all.

#cinclude once "sqlite3.h"
#foreignlib SQLITE static "vendor/sqlite3"

function OnRow ( byval user as any ptr, byval ncols as long, _
                       byval values as zstring ptr ptr, _
                       byval names as zstring ptr ptr ) as long
	print *values[0]
	return 0
end function

dim as sqlite3 ptr db
sqlite3_open( @":memory:", @db )
sqlite3_exec( db, @"select name from part;", @OnRow, 0, 0 )
sqlite3_close( db )
```

Naming the header through the folder — `#cinclude once "vendor/sqlite3.h"` — needs no `-cinclude` **when fbc is run from the directory that contains `vendor/`**, which is how the shipped example is built. From anywhere else it needs `-cinclude path/to/vendor`, because the path is resolved against the working directory and not against the file that wrote it.

## Pages in this category

[#cinclude](modern-Cinclude) ✨ · [#cinclude Tutorial](modern-Cinclude-tutorial) ✨

---

**Source:** `docs/cimport/cimport.txt` in the tiko-lang repository.

---

[Home](Home) · [Keyword Index](Keyword-Index)
