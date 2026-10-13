# Using C libraries

Chapter 28 showed how tiko talks to C: `#cinclude` reads a header, `#foreignlib` links a
library, and a C function is then called like any other. It did that with `geom`, a four-function
library written for the chapter, whose files were already laid out the way tiko wanted them.

Real libraries do not arrive that way. They come as an archive from a project's website, with the
files arranged the way their authors chose, built for compilers you may not have, in several
variants whose differences the archive does not explain. Before the first line of your program
compiles you have to choose a package, unpack it, decide which file to link, and make sure the
program can find the library again when it runs, on your machine and on someone else's.

This chapter does all of that for four of the most widely used C libraries:

| Library | Version | What it is for | Licence |
|---|---|---|---|
| **SQLite** | 3.54.0 | an SQL database in a single file, with no server | public domain |
| **raylib** | 6.0 | games and graphics: windows, drawing, input, sound | zlib |
| **GLFW** | 3.5.1 | a window and an OpenGL context, and the input that goes with them | zlib |
| **SDL3** | 3.4.18 | windows, rendering, audio, input and more, for games and media | zlib |

Each one is taken from its download page to a running program, linked both **statically** and
**dynamically**, kept either **inside the project** or **installed once** for every program on
the machine, on Windows and on Linux. The programs are the libraries' own first examples,
translated into tiko, so you can put them beside the library's documentation and read the two
together.

Every listing in this chapter was compiled and run on both platforms, against exactly the
versions in the table, except one that a Status callout explains.

## Before you start

You need tiko and LLVM, as Chapter 1 set up. Three more tools are used in this chapter:

- **On Windows, the Visual Studio Build Tools with the Windows SDK.** `#cinclude` hands each
  header to clang, and on Windows clang reads the C runtime's and the Windows SDK's headers from
  that installation. Without it, a library header that includes `<stdio.h>` cannot be imported,
  and tiko says so:

  ```text
  note: windows-x86_64 imports against the installed MSVC and Windows SDK
  headers; install Visual Studio Build Tools with the Windows SDK, or name
  the directory with -cinclude
  ```

  tiko itself does not need Visual Studio; `#cinclude` does. Install the free Build Tools and
  select *Desktop development with C++*. The same installation is what compiles C code on
  Windows, with clang or with Visual C++, which this chapter does twice.
- **CMake**, from `cmake.org` or your package manager, to build GLFW and SDL from their source.
- **On Linux, a C compiler and the development packages** a library lists. They are named in each
  library's section.

The shell commands in this chapter are written for **bash**, and the same commands work on both
platforms: on Windows, run them in Git Bash, which comes with Git for Windows. The LLVM tools they
use (`clang`, `llvm-lib`, `llvm-dlltool`) are in LLVM's `bin` directory, `C:\Program Files\LLVM\bin`
by default; add it to `PATH`, or write the full path.

## What a library package contains

Open any C library's download and you find the same few kinds of file, under different names.

| File | Windows | Linux | What it is for |
|---|---|---|---|
| header | `.h` | `.h` | the declarations: what `#cinclude` reads |
| static library | `.lib` | `.a` | the library's compiled code, copied into your program when it links |
| shared library | `.dll` | `.so`, `.so.6`, `.so.6.0.0` | the compiled code as a separate file, loaded when your program starts |
| import library | `.lib` | none | Windows only: a small file that tells the linker which DLL holds each function |

On Windows, `.lib` means two different things. A **static** `.lib` holds the library's code; an
**import** `.lib` holds none, only the names of the functions and the name of the DLL they live
in. You cannot tell them apart by the name, only by the size and by the package's documentation:
raylib's `raylib.lib` is 5 MB of code, its `raylibdll.lib` 400 KB of names.

The linker never reads a `.dll`. To link with a DLL, you link with its import library, and the
DLL is used only when the program runs. If a package ships a DLL without one, you make one; the
SQLite section shows how.

### Choosing the right package

Libraries publish several builds of the same version. Two choices matter for tiko:

- **64-bit only.** tiko builds x86-64 programs. A package marked `win32`, `x86`, `i386` or
  `i686` cannot be linked into them.
- **On Windows, the Visual C++ build.** tiko's Windows target, `windows-x86_64`, uses Microsoft's
  conventions and Microsoft's C runtime, the same as Visual C++. Packages are labelled `msvc`,
  `VC`, `vc2022` or similar. The `mingw` packages are built for GCC's conventions on Windows,
  and are not the ones this chapter uses.

On Linux the choice is simpler: a library built by your distribution's compiler, for x86-64.

## Static or dynamic

Every library in this chapter can be linked either way. The difference is where its code ends up.

**Linked statically**, the library's code is copied into your program. The program is one file;
nothing can go missing when it is copied to another machine; and only the parts of the library
the program uses are copied in. It is larger, and updating the library means relinking it.

**Linked dynamically**, your program holds only references to the library, and the library's own
file, the DLL or `.so`, must be present when the program starts. The program is small, several
programs can share one copy of the library, and the library can be updated without relinking.
But the program now comes in two parts, and the second part has to be found.

Measured on the programs in this chapter, each linked both ways, in kilobytes of 1,000 bytes:

| Program | Windows, static | Windows, dynamic | Linux, static | Linux, dynamic |
|---|---:|---:|---:|---:|
| `sqlite-quick` | 1,168 | 38 + 3,519 | 1,114 | 44 + 1,197 |
| `raylib-window` | 608 | 27 + 1,905 | 996 | 35 + 2,100 |
| `glfw-window` | 227 | 29 + 234 | 331 | 35 + 353 |
| `sdl-clear` | 2,745 | 29 + 2,848 | 3,604 | 40 + 4,096 |

(The static SDL program on Windows does not link yet, for a reason the SDL section explains; its
size was measured with the missing piece supplied by hand.)

The second figure in each dynamic column is the shared library that has to travel with the
program. A static program is smaller than the program plus its library, because the linker copies
in only what is called.

All four licences allow either way. That is not true of every library: under the LGPL, for
instance, linking statically brings obligations that linking dynamically does not. Read a
library's licence before you decide.

### Where a program finds its shared libraries

**On Windows**, a program looks for a DLL first in **its own directory**, then in the system
directories, then in the current directory and the directories on `PATH`. Put the DLL beside the
`.exe` and it is found. When it is not, the program does not start; from a console it exits at
once with code `-1073741515`, which is `0xC0000135`, *DLL not found*, and prints nothing.

**On Linux**, a program looks for a `.so` in the directories listed in `LD_LIBRARY_PATH`, then
in the system's library directories (`/usr/lib`, `/usr/local/lib` and the others the system's
`ldconfig` knows), and **not** in its own directory. When it fails, it says so:

```text
./raylib-dll: error while loading shared libraries: libraylib.so.600:
cannot open shared object file: No such file or directory
```

and exits with code 127. The name it looks for is the library's **soname**, a name recorded
inside the `.so` when it was built (`libraylib.so.600`), not the name of the file you linked.
That is why a Linux package carries the same library under three names, such as
`libraylib.so`, `libraylib.so.600` and `libraylib.so.6.0.0`: the first is for the linker, the
second is the soname the program will ask for, and the third is the real file.

For a library installed on the system, nothing more is needed. For one inside your project, run
the program with the project's directory on `LD_LIBRARY_PATH`:

```bash
LD_LIBRARY_PATH=. ./sqlite-quick
```

````admonish warning title="Status in this version"
A Linux program usually solves this with an **rpath**: a directory recorded in the program, often
`$ORIGIN`, meaning "beside me". tiko has no way to give the linker one yet, and no option that
passes arguments to the linker unchanged, as fbc's `-Wl` does (T99). Until it does, a program
linked with a library inside its project needs `LD_LIBRARY_PATH` or a small launch script, kept
beside the program as, say, `run-game`, that sets it:

```bash
#!/bin/sh
here="$(dirname "$(readlink -f "$0")")"
LD_LIBRARY_PATH="$here${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" exec "$here/game" "$@"
```
````

```admonish danger title="Pitfall"
**On Linux, a missing library is not always an error.** Ubuntu has `libsqlite3.so.0` installed
for its own use. A program linked with the SQLite 3.54.0 in this chapter's project asks for that
same soname, so run without `LD_LIBRARY_PATH` it starts without complaint, using the system's
copy, an older version, and nothing says so. The same program prints `SQLite 3.54.0` with
`LD_LIBRARY_PATH=.` and `SQLite 3.45.1` without it. A program that depends on a newer feature
fails much later, and somewhere that looks unrelated. When it matters which copy is loaded, check
it the way the listings here do: ask the library for its version.
```

### A static library brings its dependencies with it

A static library is the library's code and nothing else. Whatever *that* code calls becomes your
program's to link. raylib calls Windows' multimedia timer, so a program that links raylib
statically must also link `winmm`; SDL asks Windows about the devices plugged in, so it needs
`setupapi`. A shared library carries those links inside itself, which is why the dynamic listings
in this chapter name no system libraries.

`#foreignlib` takes them after the library itself, each as `"system:name"`:

```tiko
#foreignlib RAYLIB static "vendor/raylib/raylib", _
    "system:winmm", "system:gdi32", "system:user32", "system:shell32"
```

To find the list for a library, look first in its documentation: most say what a static build
needs. If they do not, link without any and read what the linker cannot find:

```text
lld-link: error: undefined symbol: __declspec(dllimport) SetupDiGetClassDevsA
lld-link: error: undefined symbol: __declspec(dllimport) CoInitializeEx
lld-link: error: undefined symbol: __declspec(dllimport) SysFreeString
```

Each name is a function of the operating system. On Windows, Microsoft's documentation for the
function names the library in its *Requirements* table: `SetupDiGetClassDevsA` is in
`setupapi.lib`, `CoInitializeEx` in `ole32.lib`, `SysFreeString` in `oleaut32.lib`. On Linux,
the manual page or the package that provides the function says which library holds it. Add one
`system:` entry for each library, and link again until nothing is missing.

## Vendored or installed

Separately from static or dynamic, you choose where the library lives.

**Vendored** means the project carries its own copy, in a directory of its own, usually
`vendor/`. Anyone who checks out the project can build it with nothing to install; the version is
the one you tested with, and stays that way until you change it; and two projects can use two
different versions without meeting. The cost is that each project carries its own copy.

**Installed** means one copy, in a shared place, used by every program on the machine. On Linux
that place exists already, and the package manager fills it. On Windows there is no such place for
C libraries, so you make one.

### A vendored library

`#foreignlib` and `#cinclude` were built for vendoring. `#foreignlib` resolves its path relative
to the file that contains the directive, so a program finds its libraries wherever it is built
from. `#cinclude` finds a quoted header under the working directory or beside the file that names
it, as Chapter 28 described.

`#foreignlib` also chooses the file **for the target**. Given `"vendor/raylib/raylib"`, it tries
`raylib_windows_x86_64`, `raylib_windows`, `raylib_x86_64` and plain `raylib`, each with the
target's extensions. So both platforms' files can sit side by side, and one directive serves
both:

```text
vendor/raylib/raylib.h
vendor/raylib/raylib_windows_x86_64.lib       static, for Windows
vendor/raylib/raylib_linux_x86_64.a           static, for Linux
vendor/raylib/raylibdll_windows_x86_64.lib    import lib for raylib.dll
vendor/raylib/raylibdll_linux_x86_64.so       libraylib.so.600, renamed
raylib.dll                                    beside the program
libraylib.so.600                              beside the program
```

The target tags are not optional when both platforms share a folder. On Windows a static search
tries `.a` before `.lib`, so an untagged `raylib.a` built for Linux is found first, and the link
fails with an error that does not say why: `lld-link: error: unknown file type: rcore.o`.

Notice which files are renamed and which are not. You rename the files the **linker** reads, to
give them their target tags. You never rename the files the program loads when it **runs**: the
DLL keeps the name its import library records (`raylib.dll`) and the `.so` keeps its soname
(`libraylib.so.600`), because those are the names the program will ask for.

This chapter's listings use a vendored copy of each library. The script
`examples/ch29/fetch-libs.sh` builds that `vendor/` directory: it downloads each package, checks
it against a SHA-256 checksum, and copies and renames the files, building the ones that have no
download. Run it once on each platform:

```bash
bash fetch-libs.sh
```

It is also the exact record of every step in this chapter, in order. When the prose says "copy
this file there", the script is where to look to see it done.

### An installed library

On **Linux**, the package manager installs a library's header into `/usr/include` and the library
into `/usr/lib/x86_64-linux-gnu`. A library you build yourself and install with
`sudo cmake --install build` goes to `/usr/local/include` and `/usr/local/lib`. All four
directories are searched by default, both by `#cinclude`'s clang and by the linker, so a program
names neither:

```tiko
#cinclude once "sqlite3.h"
#foreignlib SQLITE dynamic "system:sqlite3"
```

`"system:sqlite3"` hands `sqlite3` to the linker the way `#inclib "sqlite3"` would, and the
linker finds `libsqlite3.so`. Two things to know about it: the `static` or `dynamic` before a
`system:` spec is **not checked**, and when a directory has both `libsqlite3.so` and
`libsqlite3.a`, the linker takes the `.so`. After installing a library into `/usr/local/lib`
yourself, run `sudo ldconfig` once, so that programs can find it when they start.

On **Windows** you choose a folder, such as `C:\tiko-libs`, and put each library in it the same
way as `vendor/`. A program then needs to be told where that folder is, which is the job of a
**binding header**, at the end of this chapter.

## SQLite

SQLite is an SQL database engine in a library: no server to install or start, and a whole
database is one ordinary file. Its authors describe it as the most widely deployed database
engine in the world, and it is inside many of the programs you already use.

```admonish note
tiko already ships SQLite. The toolchain's `db/sqlite` module wraps a copy that is linked into
the program, and Chapter 27 uses it. This section is for the cases that module does not cover:
a newer SQLite than the toolchain's, SQLite's own C interface rather than tiko's, or SQLite built
with options of your own.
```

### Downloading

Everything is on the download page, `https://sqlite.org/download.html`:

| File | What is in it |
|---|---|
| `sqlite-amalgamation-3540000.zip` | `sqlite3.c` and `sqlite3.h`: the **whole library as one C file**, with its header |
| `sqlite-dll-win-x64-3540000.zip` | `sqlite3.dll` and `sqlite3.def`, the library already built for 64-bit Windows |
| `sqlite-autoconf-3540000.tar.gz` | the same `sqlite3.c` and `sqlite3.h`, with a build script, for Unix |

The number in each name is the version: 3.54.0 is `3540000`.

SQLite is unusual in shipping its source as one file. It is meant to be compiled into your
program directly, which makes a static library easy to build yourself.

### Windows: the dynamic library

The DLL zip has `sqlite3.dll` and `sqlite3.def`, a text file that lists every function the DLL
exports, but **no import library**. Make one from the `.def` with `llvm-dlltool`, which comes
with LLVM:

```bash
llvm-dlltool -m i386:x86-64 -d sqlite3.def -D sqlite3.dll \
    -l vendor/sqlite/sqlite3_windows_x86_64.lib
```

`-m i386:x86-64` asks for a 64-bit import library, `-d` names the export list, `-l` the library
to write, and `-D` the DLL that the program will load. The import library records that name, and
the program asks for exactly that file when it starts.

````admonish danger title="Pitfall"
**An import library with no DLL name links, and the program then cannot start.** `sqlite3.def`
has no `LIBRARY` line naming its DLL, so the name must come from the command line. Made with
`llvm-lib /def:sqlite3.def` and no name, the import library is accepted, the program links
cleanly, and running it fails at once with `0xC0000135`: Windows was asked to load a DLL called
nothing. `llvm-readobj --coff-imports` on the `.exe` shows it, an import block with an empty
`Name:`. Give the name with `-D sqlite3.dll`, or add a first line `LIBRARY sqlite3.dll` to the
`.def`.
````

```admonish warning title="Status in this version"
`#foreignlib … dynamic` will match a bare `sqlite3.dll` if there is no import library beside it,
and hands it to the linker, which refuses: `lld-link: error: sqlite/sqlite3.dll: bad file type.
Did you specify a DLL instead of an import library?` (T98). Make the import library as above.
```

Put `sqlite3.dll` beside the program.

### Windows: the static library

Compile the amalgamation with clang and put the one object in a library with `llvm-lib`:

```bash
clang -c -O2 -o sqlite3.obj sqlite3.c
llvm-lib /out:vendor/sqlite/sqlite3-static_windows_x86_64.lib sqlite3.obj
```

It takes about twenty seconds; `sqlite3.c` is over nine megabytes of C. On Windows clang compiles
for Microsoft's conventions by default, the same as tiko, and finds the C runtime's headers in
the Visual Studio Build Tools. Since a static `.lib` and an import `.lib` cannot share a name, the
static one is called `sqlite3-static`.

### Linux

The same two libraries, from the autoconf archive's `sqlite3.c`:

```bash
gcc -O2 -fPIC -c -o sqlite3.o sqlite3.c
ar rcs vendor/sqlite/sqlite3-static_linux_x86_64.a sqlite3.o
gcc -shared -Wl,-soname,libsqlite3.so.0 \n    -o vendor/sqlite/sqlite3_linux_x86_64.so sqlite3.o -lm
cp vendor/sqlite/sqlite3_linux_x86_64.so libsqlite3.so.0
```

`-fPIC` makes code that works at any address, which a shared library needs. `-Wl,-soname,…`
records the soname, the name a program linked with the library will look for. Without one, the
program would record the path it was linked with, `vendor/sqlite/sqlite3_linux_x86_64.so`, and
work only from the directory it was built in. The last line puts the library beside the
program under its soname.

To install SQLite for every program instead, use the distribution's package, which installs both
the header and the library:

```bash
sudo apt install libsqlite3-dev
```

### A first program

SQLite's documentation opens with a short C program, *SQLite In 5 Minutes Or Less*: it opens the
database named by its first argument, runs the SQL in its second, and prints every row of the
result. Here it is in tiko, linked dynamically:

```tiko
{{#include ../examples/ch29/sqlite-quick.tiko:all}}
```

Run with an in-memory database and four statements, one string that the shell lets run over
several lines:

```bash
./sqlite-quick :memory: "create table tbl1(one text, two int);
    insert into tbl1 values('hello!', 10);
    insert into tbl1 values('goodbye', 20);
    select * from tbl1"
```

```text
{{#include ../examples/ch29/sqlite-quick.out}}
```

The two directives at the top are the whole connection to SQLite. Everything else is the C
program, line for line, and it shows the parts of Chapter 28 that a real library uses most:

- **Opaque handles.** `sqlite3` is a struct the header declares but never defines, so a program
  can hold only a pointer to one. `sqlite3_open` fills `db` through its address, `@db`, the way
  the C passes `&db`.
- **Strings into C.** `command( 2 )` is a tiko string; passed where the header says
  `const char *`, the compiler passes a pointer to its bytes.
- **Strings out of C.** `sqlite3_errmsg` returns `const char *`, and `*sqlite3_errmsg( db )` copies
  the text into a tiko string.
- **A callback.** `sqlite3_exec` calls `Callback` once per row, so `Callback` is `cdecl` and takes
  exactly the parameters the header's function pointer type says: `void *`, `int`, and two
  `char **`, which are `zstring ptr ptr`. `argv[i]` is the `i`th column's text, or a null
  pointer for SQL's `NULL`.
- **Memory C allocated.** On failure, `sqlite3_exec` points `errMsg` at a message SQLite
  allocated; SQLite's documentation says to free it with `sqlite3_free`, so the program does.

### Prepared statements, linked statically

Gluing values into SQL text is how SQL injection happens, and the text has to be parsed again
for every row. Real programs **prepare** a statement once, with `?` where the values go, and then
**bind** a value to each `?`. This program does that, linked statically:

```tiko
{{#include ../examples/ch29/sqlite-bind.tiko:all}}
```

```text
{{#include ../examples/ch29/sqlite-bind.out}}
```

Only the `#foreignlib` line differs from the dynamic program:

```tiko
{{#include ../examples/ch29/sqlite-bind.tiko:link}}
```

`static` instead of `dynamic`, and the static library's base name. The program now needs no DLL:
copied to another machine, it runs.

A few things in it come from SQLite's interface rather than from tiko:

- `sqlite3_prepare_v2` compiles the SQL once; `sqlite3_bind_text` and `sqlite3_bind_int` fill
  the `?`s, counting from 1; `sqlite3_step` runs it, returning `SQLITE_ROW` for each row and
  `SQLITE_DONE` at the end; `sqlite3_reset` makes it ready to run again; and
  `sqlite3_finalize` frees it.
- The last argument of `sqlite3_bind_text` says whether SQLite must copy the text.
  `SQLITE_STATIC`, which is a null pointer, promises the string will outlive the statement's use
  of it, which `names( i )` does. `SQLITE_TRANSIENT` asks SQLite to copy. Both are C macros that
  **cast** a number to a function pointer, and the importer does not bring such macros across;
  write `nullptr` for the first and `cast( sqlite3_destructor_type, -1 )` for the second.
- `sqlite3_column_text` returns `const unsigned char *`, so tiko sees a `const ubyte ptr`. Cast it
  to a `zstring ptr` to read it as text.
- `names` is an array of `string`, tiko's byte string, because SQLite's `_text` functions take
  UTF-8 bytes.

## raylib

raylib is a library for making games, designed to be easy to learn: one header, 600 functions
with plain names, and no setup beyond opening a window. It draws with OpenGL and handles the
keyboard, mouse, gamepads, sound, textures, fonts and 3D models.

### Downloading

raylib publishes prebuilt packages on GitHub, `https://github.com/raysan5/raylib/releases`. For
6.0, two are for tiko:

| File | What is in it |
|---|---|
| `raylib-6.0_win64_msvc16.zip` | `include/raylib.h` (and `raymath.h`, `rlgl.h`); `lib/raylib.lib`, static; `lib/raylibdll.lib`, the import library; `lib/raylib.dll` |
| `raylib-6.0_linux_amd64.tar.gz` | the same headers; `lib/libraylib.a`, static; `lib/libraylib.so.6.0.0` with its links `libraylib.so.600` and `libraylib.so` |

The other packages on the page are for 32-bit Windows (`win32`), the MinGW compiler, ARM, macOS
and the web.

### Installing it in a project

From the Windows package:

| From the package | Into the project |
|---|---|
| `include/raylib.h` | `vendor/raylib/raylib.h` |
| `lib/raylib.lib` | `vendor/raylib/raylib_windows_x86_64.lib` |
| `lib/raylibdll.lib` | `vendor/raylib/raylibdll_windows_x86_64.lib` |
| `lib/raylib.dll` | `raylib.dll`, beside the program |

From the Linux package:

| From the package | Into the project |
|---|---|
| `include/raylib.h` | `vendor/raylib/raylib.h` (the same file) |
| `lib/libraylib.a` | `vendor/raylib/raylib_linux_x86_64.a` |
| `lib/libraylib.so.6.0.0` | `vendor/raylib/raylibdll_linux_x86_64.so` |
| `lib/libraylib.so.6.0.0` | `libraylib.so.600`, beside the program |

The dynamic base name is `raylibdll` on both platforms, after the Windows import library, so that
one `#foreignlib` line finds the right file on each.

### Installing it for every program

On **Linux**, recent distributions package raylib as `libraylib-dev`; Ubuntu 24.04 does not.
Without a package, copy the prebuilt files into `/usr/local` and refresh the loader's cache:

```bash
sudo cp include/*.h /usr/local/include/
sudo cp -P lib/libraylib.* /usr/local/lib/
sudo ldconfig
```

`cp -P` copies the two links as links. A program then writes `#cinclude once "raylib.h"` and
`#foreignlib RAYLIB dynamic "system:raylib"`.

On **Windows**, see *A binding header* below.

### A first window

raylib's examples start with `core_basic_window`, which opens a window and writes one line of
text in it:

```tiko
{{#include ../examples/ch29/raylib-window.tiko:all}}
```

```text
{{#include ../examples/ch29/raylib-window.out}}
```

![The window that `raylib-window` opens.](img/ch29-raylib-window.png)

Everything after the directives is raylib's example as it is written in C. A few lines are new:

- **Linked statically**, raylib needs a different set of system libraries on each platform, so
  the `#foreignlib` line is chosen with `#ifdef __FB_WIN32__`. On Linux it is the list raylib's
  documentation gives: OpenGL, the maths library, threads, `dl`, `rt` and X11.
- **`SetTraceLogLevel( LOG_WARNING )`** comes first because raylib reports everything it does,
  about forty lines when a window opens, on standard output. The listings keep it quiet so that
  their output is the program's own.
- **`maxFrames`** lets the program stop by itself after a number of frames given on the
  command line, so this book's checks can run it. Started with no argument, it runs until you
  close the window, as raylib's example does.

Two things come through `#cinclude` that look like more than declarations. `RAYWHITE` and
`LIGHTGRAY` are C macros that build a struct, `CLITERAL(Color){ 245, 245, 245, 255 }`; the
importer turns each into a tiko `#define` that builds the same `Color`. And `DrawText` takes
that `Color` **by value**, a four-byte struct passed the way C passes it, as Chapter 28
described for `geom_point`.

### Linked dynamically

The same program, with its first lines replaced:

```tiko
{{#include ../examples/ch29/raylib-dll.tiko:link}}
```

No system libraries this time: `raylib.dll` and `libraylib.so.600` already link everything they
need. The program is 27 KB instead of 608 KB on Windows, and the DLL must travel with it.

## GLFW

GLFW does less than raylib, on purpose. It creates windows, gives each one an **OpenGL context**,
the surface OpenGL draws on, and reports keyboard, mouse, gamepad and window events. All drawing
is left to OpenGL, or to Vulkan. It is the library to reach for when you want to write the
graphics code yourself.

### Downloading

On **Windows**, take *64-bit Windows binaries* from `https://www.glfw.org/download.html`,
`glfw-3.5.1.bin.WIN64.zip`. It holds `include/GLFW/glfw3.h` and one folder of libraries per
compiler:

| Folder | What is in it |
|---|---|
| `lib-vc2022` | **the one to use:** `glfw3.lib`, static; `glfw3dll.lib`, the import library; `glfw3.dll` |
| `lib-vc2017`, `lib-vc2019`, `lib-vc2026` | the same, from other Visual C++ versions |
| `lib-static-ucrt` | a DLL built with the C runtime linked into it |
| `lib-mingw-w64` | for the MinGW compiler |

`lib-vc2022` also has `glfw3_mt.lib`. GLFW's own `README.md` explains the difference: `glfw3.lib`
is for programs that use the C runtime as a DLL, and `glfw3_mt.lib` for programs that link it
statically. tiko's programs use the C runtime DLL, `ucrtbase.dll`, so take `glfw3.lib`.

On **Linux**, GLFW publishes source only: `glfw-3.5.1.zip` from the same page. Its documentation
lists what building it needs, for both of Linux's window systems, X11 and Wayland:

```bash
sudo apt install libwayland-dev libxkbcommon-dev xorg-dev
```

Then build it twice with CMake, once as a static library and once as a shared one (a `\` at
the end of a line continues the command on the next):

```bash
cmake -S glfw-3.5.1 -B build-static -DCMAKE_BUILD_TYPE=Release
cmake --build build-static
cmake -S glfw-3.5.1 -B build-shared -DCMAKE_BUILD_TYPE=Release \n    -DBUILD_SHARED_LIBS=ON
cmake --build build-shared
```

`build-static/src/libglfw3.a` becomes `vendor/glfw/glfw3_linux_x86_64.a`, and
`build-shared/src/libglfw.so.3` becomes both `vendor/glfw/glfw3dll_linux_x86_64.so` and, beside
the program, `libglfw.so.3`. To build for Wayland alone, without the X11 packages, add
`-DGLFW_BUILD_X11=OFF`; this book's checks were built that way.

To install GLFW for every program on Linux, `sudo apt install libglfw3-dev` gives the
distribution's version, which on Ubuntu 24.04 is 3.3.10; or run `sudo cmake --install
build-shared` after the build above.

### A window and an OpenGL context

GLFW's documentation shows this program first: a window, an OpenGL context, and a loop that
clears the window until it is closed.

```tiko
{{#include ../examples/ch29/glfw-window.tiko:all}}
```

```text
{{#include ../examples/ch29/glfw-window.out}}
```

`glClear` and `GL_COLOR_BUFFER_BIT` are not GLFW's. They are OpenGL's, declared in `GL/gl.h`,
which `glfw3.h` includes for you, so `#cinclude` imports them along with GLFW's own declarations.
But the code behind them is OpenGL's, in `opengl32.dll` on Windows and `libGL.so` on Linux, so
the program links OpenGL itself: `"system:opengl32"` and `"system:GL"`. A program that called
only GLFW would not need them.

`OnError` is a **callback** GLFW calls whenever something fails, with an error code and a
description. `glfwSetErrorCallback( @OnError )` installs it before `glfwInit`, so that even a
failure to start is explained, which is why GLFW's documentation sets it first.

The dynamic version keeps the OpenGL library, for the same reason:

```tiko
{{#include ../examples/ch29/glfw-dll.tiko:link}}
```

```admonish note
Through `opengl32.dll`, Windows offers only OpenGL 1.1, the version from 1997, which is where
`glClear` comes from. The functions of every later version are looked up while the program runs,
with `glfwGetProcAddress`, usually by a loader library such as glad. That is OpenGL's design on
every platform, not something tiko adds.
```

## SDL3

SDL, the *Simple DirectMedia Layer*, is the oldest and broadest of the four: windows, 2D
rendering, a GPU interface, audio, gamepads, cameras, file dialogs, threads and timers, on
desktop and mobile platforms alike. Many commercial games and emulators are built on it. SDL3 is
its current version.

### Downloading

From `https://github.com/libsdl-org/SDL/releases`, release 3.4.18:

| File | What is in it |
|---|---|
| `SDL3-devel-3.4.18-VC.zip` | for Visual C++: `include/SDL3/*.h`, and in `lib/x64/` the import library `SDL3.lib` and `SDL3.dll` |
| `SDL3-3.4.18.tar.gz` | the source, for Linux and for a static library on Windows |
| `SDL3-3.4.18-win32-x64.zip` | `SDL3.dll` alone, for people who run a program, not for building one |

There is no static library in the Windows package, and no Linux package at all: SDL is built from
its source for both. Into the project go `include/` as `vendor/sdl3/include/`, `SDL3.lib` as
`vendor/sdl3/SDL3_windows_x86_64.lib`, and `SDL3.dll` beside the program.

**On Linux**, SDL's `docs/README-linux.md` lists the packages its build uses; it uses whatever it
finds, so more packages give more features. Then:

```bash
cmake -S SDL3-3.4.18 -B build -DCMAKE_BUILD_TYPE=Release \n    -DSDL_STATIC=ON -DSDL_SHARED=ON
cmake --build build
```

`build/libSDL3.a` becomes `vendor/sdl3/SDL3-static_linux_x86_64.a`; `build/libSDL3.so.0` becomes
`vendor/sdl3/SDL3_linux_x86_64.so` and, beside the program, `libSDL3.so.0`. To install it for
every program, `sudo cmake --install build`; distributions newer than Ubuntu 24.04 package it as
`libsdl3-dev`.

### Headers that include each other

SDL's headers include one another the way C programs include them:

```c
#include <SDL3/SDL_stdinc.h>
```

The angle brackets mean "search the include directories", and clang finds nothing beside the file
for those. So SDL needs its `include` directory named with `-cinclude`, and a program then
writes `#cinclude once "SDL3/SDL.h"`, as a C program writes `#include <SDL3/SDL.h>`. The listing
sets it with `#cmdline`, where the directory is relative to the directory the compiler runs in;
in a project, put it in `tiko.toml` instead, where it is relative to `tiko.toml`:

```toml
[target.game]
main    = "main.tiko"
options = ["-cinclude", "vendor/sdl3/include",
           "-cdefine", "SDL_MAIN_HANDLED"]
```

### The main callbacks

SDL3 can run a program for you: instead of writing the main loop, you give SDL four functions,
and it calls the first once at the start, the second for every event, the third once per frame,
and the fourth at the end. It is SDL's recommended way to write a program, because it works the
same on platforms where a program cannot own its main loop, such as phones and the web. SDL's
example `renderer/01-clear` is written that way; here it is in tiko:

```tiko
{{#include ../examples/ch29/sdl-clear.tiko:all}}
```

```text
{{#include ../examples/ch29/sdl-clear.out}}
```


The connection to SDL comes first:

```tiko
{{#include ../examples/ch29/sdl-clear.tiko:link}}
```

- `-cinclude` names SDL's `include` directory, as above.
- `-cdefine SDL_MAIN_HANDLED` defines a C macro before the headers are read. In a C program
  that uses the callbacks, `SDL_main.h` supplies the program's `main` function, which hands the
  four callbacks to SDL. A tiko program has its own beginning, so the macro tells `SDL_main.h`
  to declare things only.
- `SDL_main.h` is where `SDL_EnterAppMainCallbacks` is declared, the function that runs the
  callbacks. It is what `SDL_main.h`'s `main` would have called, and the program calls it at the
  end, passing the four procedures by address.

The four callbacks are `cdecl` and take exactly the parameters SDL's header gives their types,
`SDL_AppInit_func` and the rest. Get one wrong, say `int32 ptr` where SDL passes `void *`, and
the compiler says so with warning `TKO0833: passing different pointer types`, but builds the
program anyway. Treat that warning as an error: called with the wrong parameter types, a callback
reads garbage.

**State without globals.** The callbacks share a window and a renderer, and a C program would
keep them in global variables, as SDL's example does. SDL offers a better place: `AppInit` gets
the address of a pointer, `appstate`, and whatever it stores there is passed to every later
callback. The listing creates one `AppState` with `new`, stores it, and `AppQuit` deletes it.

**`bool` results.** SDL3's functions return C's `bool`, and the listing compares them with
`false`: `if SDL_Init( SDL_INIT_VIDEO ) = false then`.

**Constants.** `SDL_PI_D` and `SDL_ALPHA_OPAQUE_FLOAT` are `#define`s in SDL's headers with
number values, so `#cinclude` imports them as constants.

```admonish tip
SDL reads the environment variable `SDL_VIDEO_DRIVER` to choose its video system, and the value
`dummy` gives it one that draws nowhere. A program that opens windows can then run where there is
no screen, such as on a build server, and still exercise all of its code:
`SDL_VIDEO_DRIVER=dummy ./sdl-clear 60`.
```

### SDL linked statically

SDL's Windows package has no static library, so build one from the source archive, with CMake
and the Visual Studio Build Tools:

```bash
cmake -S SDL3-3.4.18 -B build -DSDL_STATIC=ON -DSDL_SHARED=OFF
cmake --build build --config Release
```

`build/Release/SDL3-static.lib`, 13 MB, becomes `vendor/sdl3/SDL3-static_windows_x86_64.lib`.
SDL uses more of Windows than the other three, and linked statically it needs five system
libraries, found by the method from *A static library brings its dependencies with it*:

```tiko
{{#include ../examples/ch29/sdl-static.tiko:link}}
```

On Linux the static library needs nothing more: SDL finds the window system and the sound
system while the program runs, rather than linking them.

```admonish warning title="Status in this version"
On Windows, `sdl-static` does not link yet: `lld-link: error: undefined symbol:
__declspec(dllimport) strnlen`. `strnlen` is a C runtime function that `ucrtbase.dll` exports,
but the toolchain's import library for it leaves that one function out (T100). A Visual C++
static library that calls it cannot be linked until the import library is fixed. Link SDL
dynamically on Windows until then. The same listing links and runs on Linux.
```

## A binding header

Each program so far has named its library's files itself. That is fine for one program, but it
repeats in each, with the platform's system libraries every time, and it ties every program to
where the files are. Move those lines into a header of their own, a **binding header**, and a
program needs one line:

```tiko
{{#include ../examples/ch29/vendor/raylib.ti}}
```

Both paths in `raylib.ti` are relative to `raylib.ti` itself: `#foreignlib` always resolves that
way, and `#cinclude` looks beside the file that names the header. So the folder holding
`raylib.ti` and `raylib/` can be anywhere: inside one project, or in one place that every program
on the machine shares.

A program includes it by name, and the project says where the folder is with `-i`, which adds a
directory to the ones `#include` searches:

```toml
{{#include ../examples/ch29/game/tiko.toml}}
```

```tiko
{{#include ../examples/ch29/game/main.tiko:all}}
```

`tiko build game`, then `out/debug/game 60`:

```text
{{#include ../examples/ch29/game/main.out}}
```

This is raylib's example `core_input_keys`, which moves a ball with the arrow keys. Its `ball` is
a `Vector2`, a struct of two `float`s, filled with `type( … )` and passed by value to
`DrawCircleV`; `KEY_RIGHT` and the other keys are the values of a C `enum`.

That is the Windows answer to "install once for every program". Put each library's folder and
its binding header in one place, say `C:\tiko-libs`:

```text
C:\tiko-libs\raylib.ti
C:\tiko-libs\raylib\raylib.h
C:\tiko-libs\raylib\raylib_windows_x86_64.lib
```

Then every project that uses raylib writes `#include once "raylib.ti"` and adds
`options = ["-i", "C:/tiko-libs"]` to its `tiko.toml`, or `-i C:\tiko-libs` on the command
line. For a library linked dynamically, its DLL still has to be found when the program runs:
copy it beside each program, or add its folder to `PATH`.

```admonish warning title="Status in this version"
A **module** would be the natural home for a binding: installed once on `TKO_PATH`, imported with
`#import "raylib"`. But the C names that a `#cinclude` brings into a module are not public, so a
program that imports the module can reach none of them, by bare name or as `raylib.InitWindow`
(`TKO0745`). Until that is decided (T101), a binding is a header.
```

## When something goes wrong

Every failure in this table happened while this chapter was being written.

| What you see | What it means | What to do |
|---|---|---|
| `TKO0336: unable to import C header`, and a clang note `file not found` | clang cannot find the header, or a header it includes | check the path; for `#include <…>` inside the header, add `-cinclude` |
| the same, with a note about the Windows SDK | the Visual Studio Build Tools are missing | install them, with the Windows SDK |
| `TKO0329: #foreignlib found no matching library file`, with a list of names tried | no file has any of the names in the list | rename the library to one of them, usually with its target tag |
| `lld-link: error: … bad file type. Did you specify a DLL instead of an import library?` | `#foreignlib` matched a `.dll` (T98) | make an import library |
| `undefined symbol: …` when linking statically | a system library the static library needs is not linked | add it as `"system:name"`; see *A static library brings its dependencies with it* |
| the program exits at once, code `-1073741515` (`0xC0000135`) | Windows cannot find a DLL, or the import library names none | put the DLL beside the program; check the import library has the DLL's name |
| `error while loading shared libraries: libX.so.N` and exit 127 | Linux cannot find the `.so` | `LD_LIBRARY_PATH=.`, or install the library |
| the program runs but reports an older version of the library | Linux found the system's copy, not yours | `LD_LIBRARY_PATH=.`; ask the library its version |
| a C library prints pages of messages | many libraries log to standard output | look for a log level in the library: raylib's is `SetTraceLogLevel` |
| `warning TKO0833: passing different pointer types` where a callback is passed | the callback's parameters differ from the C type | make them match the header exactly |

## What it costs

- **Calling a C library costs what calling C costs**, as in Chapter 28: no wrapper, no conversion
  beyond what the C function itself would need.
- **Static linking costs size**: the table in *Static or dynamic* shows from 200 KB to 2.7 MB
  added to each program. **Dynamic linking costs a second file** that must be shipped and found.
- **A vendored library costs space in every project** that uses it, and keeping it current is
  your job. **An installed library costs reproducibility**: the program is built and run with
  whatever version the machine has.
- **The first `#cinclude` of a large header costs time**: compiling `sdl-clear` took 1.3 seconds
  the first time and 0.23 seconds once its binding was in the cache.

## Summary

- A C library comes as a header, a static library, a shared library and, on Windows, an import
  library. On Windows take the 64-bit Visual C++ package.
- Linked **statically**, the library's code is copied into the program, which then needs nothing
  else, but links the system libraries the static library calls, each as `"system:name"`.
- Linked **dynamically**, the program is small and the library file must be found when it starts:
  beside the `.exe` on Windows, on `LD_LIBRARY_PATH` or in the system's directories on Linux.
  tiko cannot yet record an rpath (T99).
- A Linux program asks for a library by its **soname**; a missing library may silently be
  replaced by the system's own copy.
- A **vendored** library lives in the project. Name its link-time files with target tags,
  `name_windows_x86_64.lib` and `name_linux_x86_64.a`, and one `#foreignlib` line serves both
  platforms. Never rename the runtime files.
- An **installed** library on Linux needs no paths: `#cinclude once "x.h"` and `"system:x"`. On
  Windows, make a shared folder and point at it with `-i`.
- **SQLite**: compile the amalgamation for a static library; make an import library from
  `sqlite3.def` with `llvm-dlltool -D sqlite3.dll`.
- **raylib**: prebuilt for both platforms; quiet it with `SetTraceLogLevel`.
- **GLFW**: `lib-vc2022/glfw3.lib` on Windows, built from source on Linux; a program that calls
  OpenGL links OpenGL itself.
- **SDL3**: its `include` directory goes to `-cinclude`; `SDL_MAIN_HANDLED` and
  `SDL_EnterAppMainCallbacks` run the main callbacks; `appstate` replaces globals.
- A **binding header** holds a library's `#cinclude` and `#foreignlib` lines, relative to itself,
  so programs include one file and need not know where the library is.

## Exercises

1. Run `sqlite-quick` with a file name instead of `:memory:`, once to create a table and insert a
   row, and again to select it. Then open the file with SQLite's own `sqlite3` command-line tool,
   from the *precompiled binaries* on the download page.
2. Link `sqlite-quick` statically and compare its size and its start-up with the dynamic version.
   On Linux, run both without `LD_LIBRARY_PATH` and explain the difference in what they print
   with a `select sqlite_version()`.
3. In `raylib-window.tiko`, draw the frame number in the window with raylib's `TextFormat`, which
   is variadic like C's `printf`. What type must the argument have for `%i`?
4. Add a key callback to `glfw-window.tiko` with `glfwSetKeyCallback`, so that Escape closes the
   window by calling `glfwSetWindowShouldClose`.
5. Make `sdl-clear.tiko`'s `AppEvent` return `SDL_APP_SUCCESS` when Escape is pressed: an event
   whose `type` is `SDL_EVENT_KEY_DOWN` carries the key in `event->key.key`, to compare with
   `SDLK_ESCAPE`.
6. Write a binding header `sdl3.ti` for SDL, the way `raylib.ti` is written, and a `tiko build`
   project that uses it. Which option must the project still give, and why can the binding
   header not give it for the project?
