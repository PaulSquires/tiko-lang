[Home](Home) › [Foreign Library Linking](Category-Foreign-Library-Linking) › **#foreignlib Tutorial**

# #foreignlib Tutorial

*A tutorial for FreeBASIC programmers meeting `#foreignlib` for the first time.*

You already know how to link a C library from FreeBASIC. This tutorial starts
from exactly that knowledge, shows you the three places it runs out, and then
walks you through vendoring SQLite into your own project — first as a DLL, then
as a static library.

**You need:** the tiko toolchain (`toolchains\tiko-windows\tiko.exe`), clang, which
tiko runs for every link, and about twenty minutes. `#foreignlib` does not exist
in released FreeBASIC.

Every build command and every compiler message in this tutorial was run with tiko
on Windows, 2026-09-24 (origin/master 50c71751), for tiko's default target,
win64-msvc, unless the command says `-target win64`. Where output depends on your
machine, it says so.

---

## Part 1 — What you already know

FreeBASIC gives you three constructs for linking, and each one is a thin cover
over a command-line switch.

| You write | the compiler does | You could have typed |
| --- | --- | --- |
| `#inclib "sqlite3"` | adds a library **name** to the link | `-l sqlite3` |
| `#libpath "somedir"` | adds a **search directory** | `-p somedir` |
| `declare … lib "sqlite3"` | adds a library name, same as `#inclib` | `-l sqlite3` |

That is the whole model. **You name a library; the linker goes looking for it.**

Here is the smallest real program that uses it:

```freebasic
'' old.tko
#inclib "sqlite3"
declare function sqlite3_libversion cdecl alias "sqlite3_libversion" ( ) as zstring ptr
print "sqlite " & *sqlite3_libversion( )
```

and the build:

```bash
tiko old.tko -p C:\dev\sqlite\lib\win64-dll
```

```
sqlite 3.53.4
```

If you have written FreeBASIC bindings before, none of this is new. Hold on to
one detail though: **the `-p` is not in the source file.** Nothing in `old.tko`
records where SQLite lives. That fact is the seed of all three problems below.

### An experiment worth doing

Build that same unchanged `old.tko` three ways, for the MinGW-ABI `win64` target,
and look at the sizes:

```bash
tiko -target win64 old.tko -o a.exe                                  # no -p at all
tiko -target win64 old.tko -p C:\dev\sqlite\lib\win64     -o b.exe   # dir holding libsqlite3.a
tiko -target win64 old.tko -p C:\dev\sqlite\lib\win64-dll -o c.exe   # dir holding libsqlite3.dll.a
```

```
1474560  a.exe
1474560  b.exe
 164864  c.exe
```

Three builds of one source file. Two of them baked the whole of SQLite into the
executable; one of them produced a 165 KB executable that needs `sqlite3.dll` beside it
at run time. **Nothing warned you which you got.** The only way to tell them
apart is to look at the file size, or to delete the DLL and see which one still
runs.

And look at `a.exe`, the one with no `-p`. It linked — because the tiko toolchain
ships a `lib\win64-fb\libsqlite3.a` for the `win64` target, and the bare name
found it. *(On tiko's default target, win64-msvc, the same three commands without
`-target win64` give a different answer: `a.exe` does not link —
`lld-link: error: could not open 'sqlite3.lib': no such file or directory` — nor
does `b.exe`, because `libsqlite3.a` is a MinGW archive (`undefined symbol:
___chkstk_ms`), and `c.exe` links at 23,552 bytes. Which outcome you get is a
property of your installation and your target, not of your program — which is
rather the point.)*

Keep that experiment in mind. Everything `#foreignlib` does is aimed at it.

---

## Part 2 — The three places it runs out

### Gap 1 — you cannot ship a library with your code

The natural way to distribute a binding is to put the library next to it:

```
mylib/
   mylib.ti          <- #libpath "vendor" + #inclib "mylib"
   vendor/libmylib.a
```

Try it. From the directory *above* `mylib`:

```
lld-link: error: could not open 'mylib.lib': no such file or directory
```

The archive is right there. The problem is that **`#libpath` is relative to the
directory you ran the compiler from**, not to the file the directive is written in. So
`#libpath "vendor"` means "a folder called vendor under wherever the user
happened to be standing". There is no string you can put in that `.ti` that
works from every working directory.

The practical consequence is that FreeBASIC bindings do not ship libraries. They
tell you to install one and pass a `-p`.

### Gap 2 — `Lib` only takes a literal

Vendors ship a library under a different name per platform -- `foo64.dll` on
64-bit Windows, `foo32.dll` on 32-bit, `libfoo.so.1` on Linux -- and you have to
select between them. The obvious fix:

```freebasic
const MYLIB = "foo64"
declare function foo_init cdecl lib MYLIB alias "foo_init" ( ) as int32
```

```
error 17: Syntax error, found 'MYLIB'
```

That is stock fbc 1.10.1. `Lib` requires a **string literal**. So the whole declaration has to be
duplicated once per target:

```freebasic
#ifdef __FB_WIN32__
  #ifdef __FB_64BIT__
    declare function foo_init cdecl lib "foo64" alias "foo_init" ( ) as int32
  #else
    declare function foo_init cdecl lib "foo32" alias "foo_init" ( ) as int32
  #endif
#else
  declare function foo_init cdecl lib "foo" alias "foo_init" ( ) as int32
#endif
```

(Under tiko the `__FB_64BIT__` test can only go one way -- its targets,
win64-msvc, win64 and linux-x86_64, are all 64-bit -- so the `foo32` branch is
there for portability to stock fbc, not because this compiler can reach it.)

Three copies of one line, differing in one token — times every function in the
binding. This is why FreeBASIC binding headers are so bulky, and the copies
drift apart over time.

*(Free Pascal has allowed a named constant here since the 1990s:
`external MyLib name 'foo_init'`. It is the single biggest ergonomic difference
between the two languages' bindings.)*

### Gap 3 — nothing says static or dynamic

That is the experiment from Part 1. `#inclib "sqlite3"` hands the linker a bare
name, the linker takes whatever it finds first on the search path, and neither
tiko nor the linker tells you which kind you ended up with.

---

## Part 3 — `#foreignlib`, in terms of what you already know

One new directive:

```
#foreignlib <NAME> (static|dynamic) "<spec>" [, "<spec>" ...]
```

Mapped onto the model you know:

| Classic | `#foreignlib` | What changed |
| --- | --- | --- |
| `#inclib "sqlite3"` | `#foreignlib SQLITE dynamic "system:sqlite3"` | nothing, this is the same `-lsqlite3` |
| `#libpath "lib"` + `#inclib "sqlite3"` | `#foreignlib SQLITE dynamic "lib/sqlite3"` | the path is now relative to **this file** |
| *(no equivalent)* | `static` / `dynamic` | you state the kind; a mismatch is an error |
| *(no equivalent)* | `_windows_x86_64` suffixes | the compiler appends the target for you |
| `lib "sqlite3"` | `lib SQLITE` | a **name**, not a literal |

Three rules carry the whole design:

1. **A spec is a file, not a name.** `"lib/sqlite3"` is a path, resolved
   relative to the source file containing the directive, and the file that is
   found is handed to the linker by exact filename. `"system:foo"` is the escape
   hatch that means the old `-lfoo` behaviour -- though tiko does not honour
   it yet: see [Spec forms](#spec-forms).
2. **The kind is mandatory and is never guessed.** Ask for `static` when only a
   `.dll.a` exists and you get an error listing every path tried — not a quiet
   dynamic link.
3. **The target suffix is never written down.** You write `"lib/sqlite3"`; the
   compiler tries `sqlite3_windows_x86_64`, then `sqlite3_windows`, then
   `sqlite3_x86_64`, then `sqlite3`, with the extensions that match the kind.

And one thing that does **not** change: `#inclib` and `#libpath` still work
exactly as before, are not deprecated, and can sit in the same file as a
`#foreignlib`. You can migrate a binding one directive at a time.

---

## Part 4 — Tutorial: vendor the SQLite DLL

We are going to build a project that carries its own copy of SQLite, links it
dynamically, and builds with a bare `tiko demo.tko` from any directory.

### Step 1 — make the vendor folder

```bash
mkdir C:\dev\myapp
mkdir C:\dev\myapp\vendor\sqlite\lib
mkdir C:\dev\myapp\vendor\sqlite\bin
```

### Step 2 — copy the library in, renamed to the convention

You need two files for a dynamic link: the **import library** (what the linker
reads) and the **DLL** (what the program loads at run time).

```bash
copy C:\dev\sqlite\lib\win64-dll\libsqlite3.dll.a  C:\dev\myapp\vendor\sqlite\lib\sqlite3_windows_x86_64.dll.a
copy C:\dev\sqlite\bin\win64\sqlite3.dll           C:\dev\myapp\vendor\sqlite\bin\sqlite3.dll
```

Two things about that filename:

- **The `lib` prefix is gone.** `#foreignlib` uses the base name verbatim and
  passes the linker an exact filename, so ld's `lib*.a` convention never
  applies. Had you left it as `libsqlite3.dll.a`, the base name would be
  `"lib/libsqlite3"`.
- **`_windows_x86_64` is the target tag.** You never type it in source. It is
  what will let the same source find a `.so` on Linux later.

### Step 3 — write the linkage header

`C:\dev\myapp\vendor\sqlite\linkage.ti`:

```freebasic
#pragma once

#foreignlib SQLITELIB dynamic "lib/sqlite3"
```

That is the entire file. `"lib/sqlite3"` is relative to `linkage.ti` itself, so
it keeps working no matter where the build runs from.

### Step 4 — get a binding

Copy the FreeBASIC SQLite binding in:

```bash
copy C:\dev\sqlite\inc\sqlite3api.bi  C:\dev\myapp\vendor\sqlite\sqlite3api.bi
```

Open it and find its one linkage line, near the top:

```freebasic
#inclib "sqlite3"
```

Replace that single line with:

```freebasic
#include once "linkage.ti"
```

**That is the whole migration.** All hundred-odd `declare` statements below it
are untouched, because a `#foreignlib` contributes its library to the link
whether or not any declaration names it — exactly like `#inclib` did.

### Step 5 — write the program

`C:\dev\myapp\demo.tko`:

```freebasic
#include once "vendor/sqlite/sqlite3api.bi"

print "sqlite " & *sqlite3_libversion( )

dim as sqlite3 ptr db
if( sqlite3_open_v2( ":memory:", @db, SQLITE_OPEN_READWRITE or SQLITE_OPEN_CREATE, 0 ) <> SQLITE_OK ) then
	print "open failed: " & *sqlite3_errmsg( db )
	end 1
end if

sqlite3_exec( db, "create table t( n integer )", 0, 0, 0 )
sqlite3_exec( db, "insert into t values( 42 )", 0, 0, 0 )

dim as sqlite3_stmt ptr st
sqlite3_prepare_v2( db, "select n from t", -1, @st, 0 )
while( sqlite3_step( st ) = SQLITE_ROW )
	print "row: " & sqlite3_column_int( st, 0 )
wend
sqlite3_finalize( st )

sqlite3_close_v2( db )
```

Notice what is *not* in this file: no library name, no path, no `#ifdef`,
nothing about static or dynamic. It includes a binding and calls the API.

### Step 6 — build

```bash
cd C:\dev\myapp
tiko demo.tko
```

No `-p`. No `-l`. Then copy the DLL next to the executable and run:

```bash
copy vendor\sqlite\bin\sqlite3.dll .
demo.exe
```

```
sqlite 3.53.4
row: 42
```

### Step 7 — prove the point

The reason for all of this is that the location no longer matters. Build the
same file from the root of the drive:

```bash
cd C:\
tiko C:\dev\myapp\demo.tko
```

It links — and the executable lands next to the source, as always. `#libpath`
could not have done that.

Move `C:\dev\myapp` anywhere — another drive, another machine, into a zip and
out again — and it still links, because nothing outside the folder is named.

### Step 8 — see a failure on purpose

Rename the import library so nothing matches, and build again:

```
vendor/sqlite/linkage.ti(3,1): error TKO0329: #foreignlib found no matching library file: SQLITELIB dynamic lib/sqlite3; tried:     vendor/sqlite/lib/sqlite3_windows_x86_64.dll.a
    vendor/sqlite/lib/sqlite3_windows_x86_64.lib
    vendor/sqlite/lib/sqlite3_windows_x86_64.dll
    vendor/sqlite/lib/sqlite3_windows.dll.a
    vendor/sqlite/lib/sqlite3_windows.lib
    vendor/sqlite/lib/sqlite3_windows.dll
    vendor/sqlite/lib/sqlite3_x86_64.dll.a
    vendor/sqlite/lib/sqlite3_x86_64.lib
    vendor/sqlite/lib/sqlite3_x86_64.dll
    vendor/sqlite/lib/sqlite3.dll.a
    vendor/sqlite/lib/sqlite3.lib
    vendor/sqlite/lib/sqlite3.dll

     |
   3 | #foreignlib SQLITELIB dynamic "lib/sqlite3"
     | ^
```

The directive that failed, the line it is on, and every path that was tried, in
order. Compare it with what you would have got before:

```
lld-link: error: could not open 'sqlite3.lib': no such file or directory
```

— from a subprocess, naming no directive, no file, and no directory searched.

That listing is also the best documentation of the probe order there is. Read it
top to bottom and you can see exactly what filename to give your library.

---

## Part 5 — now link it statically

Here is the payoff. Go back to `linkage.ti` and change **one word**:

```freebasic
#foreignlib SQLITELIB static "lib/sqlite3"
```

Then put the static archive where the import library was:

```bash
copy C:\dev\sqlite\lib\win64\libsqlite3.a  C:\dev\myapp\vendor\sqlite\lib\sqlite3_windows_x86_64.a
```

Rebuild -- for the MinGW-ABI `win64` target, because `libsqlite3.a` is a MinGW
archive. On tiko's default target, win64-msvc, it does not link:
`lld-link: error: undefined symbol: ___chkstk_ms`.

```bash
tiko -target win64 demo.tko
demo.exe
```

```
sqlite 3.53.4
row: 42
```

**Nothing else changed.** Not `demo.tko`, not `sqlite3api.bi`. The `static`
keyword alone moved the build from

```
lib\sqlite3_windows_x86_64.dll.a      (import lib, needs sqlite3.dll at run time)
```
to
```
lib\sqlite3_windows_x86_64.a          (whole library, baked into the exe)
```

The base name in the directive is *identical* in both versions. There is no
second path, no second `#ifdef` branch, no renaming.

And the difference is now visible where it should be — in the executable. Both
builds are for `-target win64`; the win64-msvc `dynamic` build is 24,576 bytes:

| | size | needs `sqlite3.dll`? |
| --- | --- | --- |
| `dynamic` | 165,888 bytes | yes, beside the exe |
| `static` | 1,475,072 bytes | no |

Delete `sqlite3.dll` from the folder and run both to confirm.

### Supporting both from one source

Real bindings offer the choice. Wrap the two lines in a conditional:

```freebasic
#pragma once

#if defined( USE_STATIC_SQLITE )
	#foreignlib SQLITELIB static  "lib/sqlite3"
#else
	#foreignlib SQLITELIB dynamic "lib/sqlite3"
#endif
```

Keep **both** files in `lib\` and the caller picks at build time:

```bash
tiko -target win64 demo.tko                      -o demo_dynamic.exe
tiko -target win64 demo.tko -d USE_STATIC_SQLITE -o demo_static.exe
```

One source file, two executables, one flag. That is the working example in
`C:\dev\sqlite-test`.

### Try getting it wrong

Ask for `static` while only the `.dll.a` is present and you do **not** silently
get a dynamic link — you get TKO0329 listing the eight static candidates it
tried (`.a` and `.lib`, four name variants each). Compare with the classic
model, where pointing `-p` at the wrong directory changed your executable from
1.5 MB to 165 KB without a word.

*(One honest wrinkle: on Windows, `.lib` is accepted under **both** kinds,
because the extension genuinely does not distinguish a static archive from an
import library. Nothing can fix that from inside the compiler.)*

---

## Part 6 — reference

### Probe order

For `#foreignlib X <kind> "dir/base"`, most specific first:

```
dir/base_<os>_<arch><ext>
dir/base_<os><ext>
dir/base_<arch><ext>
dir/base<ext>
```

with every extension eligible for `<kind>` tried at each step.

| | |
| --- | --- |
| `<os>` | `windows` `cygwin` `linux` `android` `darwin` `dos` `freebsd` `openbsd` `netbsd` `dragonfly` `solaris` |
| `<arch>` | `x86` `x86_64` `arm` `aarch64` |
| `<ext>` static | Windows `.a` `.lib` · elsewhere `.a` |
| `<ext>` dynamic | Windows `.dll.a` `.lib` `.dll` · macOS `.dylib` · elsewhere `.so` |

tiko's targets only ever produce `windows` or `linux`, and `x86_64`. Measured
2026-09-24 at origin/master 50c71751, the paths it tries for win64-msvc,
`-target win64` and `-target linux-x86_64` follow this table exactly.

So a cross-platform `lib\` folder looks like this, and needs no source change:

```
lib/sqlite3_windows_x86_64.dll.a
lib/sqlite3_windows_x86.dll.a
lib/sqlite3_linux_x86_64.so
lib/sqlite3_linux_aarch64.so
```

### Spec forms

| Spec | Meaning |
| --- | --- |
| `"lib/foo"` | file, relative to the source file holding the directive |
| `"C:/abs/lib/foo"` | file, absolute |
| `"system:foo"` | hand `foo` to the linker as `-lfoo`; resolve no file |

> **tiko honours `system:` since 2026-09-25.** Before that it handed the bare
> name to clang as an input file, and `#foreignlib W static "system:winmm"`
> failed the link with `clang: error: no such file or directory: 'winmm'`
> (`TKO0116`). A `system:` name now goes to the linker exactly as `#inclib`'s
> does.

Several specs bind as one set, in link order — this is how a binding declares
what it drags in with it:

```freebasic
#foreignlib RAYLIB static "vendor/raylib", _
            "system:winmm", "system:gdi32", "system:user32"
```

### Naming the binding in a declaration

```freebasic
declare function sqlite3_libversion cdecl lib SQLITELIB alias "sqlite3_libversion" ( ) as zstring ptr
```

Note where `lib` goes: **after the calling convention, before `alias`**, not at
the end of the line. That is FreeBASIC's existing grammar, unchanged.

This is optional — the directive already did the linking — but it documents
which library a declaration belongs to, and under fbc a typo becomes error 379
instead of an undefined symbol at link time. tiko does not check the name yet:
measured 2026-09-24 at origin/master 50c71751, a misspelt name compiles, and
the program links, because the directive linked the library anyway.

### The four new errors

| fbc | tiko | |
| --- | --- | --- |
| 376 | TKO0328 | `expected STATIC or DYNAMIC after the #foreignlib name` |
| 377 | TKO0329 | `#foreignlib found no matching library file` — lists every path tried |
| 378 | TKO0330 | `#foreignlib name already bound to a different library set` |
| 379 | — | `LIB names a #foreignlib that has not been declared` — tiko does not report this yet |

A directive with nothing after `#foreignlib` is fbc's error 17 and tiko's
TKO0327. All measured 2026-09-24 at origin/master 50c71751.

Declaring the same name twice with the *same* set is fine; with a different set
it is error 378 (TKO0330), because that is a mistake rather than a rebind.

### Troubleshooting

**"It links, but the exe won't start."** Dynamic build, DLL not beside the
executable. `#foreignlib` resolves the *import* library at link time and says
nothing about deployment — copying the DLL is still your job.

**"TKO0329, but the file is right there."** Read the `tried:` list against
your actual filename. Almost always a stray `lib` prefix, or the wrong kind:
a `.dll.a` will never satisfy `static`.

**"It worked in my project folder, not from the build script."** That should no
longer happen — and if it does, check you are not still using `#libpath`
somewhere, which *is* working-directory relative.

**"I compiled a module with `-c` and its library is missing at the link."** Both
compilers record the library in the object file: its file name, and the directory
it was resolved in as an **absolute** path. Measured 2026-09-25: a module compiled
with `-c` links in a later run from another working directory. This holds with
fbc's object linked by tiko, and with tiko's object linked by fbc. Before
2026-09-25 tiko recorded nothing, and the link left the module's symbols
undefined. If the library is still missing, the object was built before its
library moved: the recorded directory is where it WAS.

---

## What this does not do

Deliberately, with reasons in
[RFC-0005 §8](https://github.com/PaulSquires/tiko-lang):

- **No package fetching.** There is no manifest, no registry, no lockfile. This
  declares how to link a library you already have.
- **No runtime loading.** Use `DyLibLoad`/`DyLibSymbol`. A directive that
  synthesised `LoadLibrary` calls would turn link errors into run-time errors.
- **No DLL deployment.** Copying `sqlite3.dll` next to the exe is a
  build-orchestration job.
- **No rpath emission**, no `+whole-archive`-style modifiers, no macOS
  frameworks.

---

## Where to go next

- [`#foreignlib`](modern-Foreignlib) — the reference page for this directive
- [Foreign Library Linking](Category-Foreign-Library-Linking) — the category
- [`#inclib`](Inclib) · [`#libpath`](Libpath) — the classic directives, unchanged
- `docs/foreignlib/foreignlib.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern) — the same
  reference as a plain-text file
- `C:\dev\sqlite-test` — the complete worked example, both link modes
- `C:\dev\docs\fb-rfcs\rfcs\0005-foreign-library-linkage.md` — the design, what was
  refused and why
- `C:\dev\docs\fb-rfcs\appendix\linkage-survey.md` — how Odin, Rust, Zig, Nim, Go,
  D, Free Pascal and C/C++ handle the same problem, which is where the design
  came from

---

**Category:** [Foreign Library Linking](Category-Foreign-Library-Linking)  
**Kind:** tutorial


---

[Home](Home) · [Keyword Index](Keyword-Index)
