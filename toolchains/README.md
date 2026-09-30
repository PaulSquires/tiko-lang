# toolchains

The **distributable** builds of tiko: what an end user downloads and unpacks, as
opposed to `bin/tiko.exe`, which is what `build/build.sh` produces for developing
the compiler itself.

One directory per host platform:

| Directory | Host | Ships |
| --- | --- | --- |
| `tiko-windows/` | Windows x86-64 | `tiko.exe`, `inc/`, `lib/win64-msvc/` (default), `lib/win64{,-fb}/` |
| `tiko-linux/`   | Linux x86-64   | `bin/tiko`, `inc/`, `include/`, `lib/linux-x86_64{,-fb}/` |

No binutils: the compiler drives **clang** for both steps -- the `.ll` to `.o`
compile and the link -- so `as` and `ld` are never invoked directly.

The top level deliberately mirrors `C:\dev\fbc-modern\toolchains\`, so a tiko
toolchain can be dropped in wherever an fbc-modern one is expected. Below `lib/`
it does not: fbc's Linux install nests its runtime one level deeper, in
`lib/freebasic/<target>`, and tiko's does not.

## Where each part comes from

| Part | Produced by |
| --- | --- |
| the compiler binary | `build/build.sh Release` -> `bin/tiko[.exe]` |
| `lib/<target>/libfb.a`, `libfbmt.a` (and on Linux `libfbpic.a`, `libfbmtpic.a`) | `lib/rt/build/build.sh Release` -> `lib/rt/lib/<target>/` |
| `lib/<target>/libtkogfx.a` | `lib/gfx/build/build.sh Release win64-msvc` -> `lib/gfx/lib/win64-msvc/`; that is the only target it builds |
| `lib/win64-msvc/*.lib` | `build/mkmsvcimplibs.sh`: MSVC-format import libraries generated from fbc's MinGW `lib<name>.dll.a` |
| `lib/<target>-fb/` | copied from the reference fbc toolchain: its startup and CRT objects, its `libfbgfx`, and on Windows its import libraries -- **not** its `libfb.a` (decision 0015) |
| `inc/` | copied from the reference fbc toolchain's headers: its `inc/` on Windows, and its `include/freebasic/` on Linux, where its `inc/` is empty |
| `include/` | copied from the reference fbc toolchain as it is; tiko does not search it |
| `lib/<target>/libfbcunit.a`, `inc/fbcunit.bi`, `src/fbcunit/` | fbcunit, built per target by `build/package.sh` from the vendored `tests/vendor/fbc-tests/fbcunit` with the compiler just packaged; its source ships because it is LGPL |

tiko ships no headers of its own yet.

## Building one

```bash
build/package.sh --verify
```

Builds the compiler, the runtime **and the graphics library** at `Release`,
assembles the tree for the
current host, then compiles **and runs** a program per target and records the
result in `MANIFEST.txt`. The program includes `fb/array.bi`, so a tree whose
headers the compiler cannot find does not pass. `--no-build` packages what is
already built, `--no-inc` skips the ~100 MB header copy, `--clean` empties the
output first, and `--help` lists the rest.

A host packages itself -- `tiko-linux` comes from running it under Linux or WSL.

The contents are gitignored, so a fresh clone has this README and nothing else;
`package.sh` creates each host's directory.

## Two directories per target

`lib/<target>/` is tiko-rt's runtime. `lib/<target>-fb/` holds what a MinGW or
glibc link needs from fbc's toolchain besides a runtime: the startup objects, and
on Windows the import libraries. A `win64` or `linux-x86_64` link uses **both, ours
first**. `win64-msvc` has no `-fb` directory and needs none.

The link gets them without being asked: the compiler appends both to its library
search relative to its own executable, the way it appends `inc/` to the include
search and the way fbc appends `lib/<target>` to its own.

```bash
tiko -target win64 yourprogram.bas
```

A `-p` is searched first and overrides either; `TKO_LIBPATH` replaces both.

Since decision 0015, tiko-rt is the whole runtime, and fbc's `libfb.a` is no longer
packaged. The compiler still names each library path's `libfb.a` as a file rather
than using `-lfb`, and only where there is one.

## Not self-contained

**clang is required and not bundled.** The compiler runs it for both the `.ll` to
`.o` step and the link. It is looked for at `C:\Program Files\LLVM\bin\clang.exe`
on Windows and `/usr/bin/clang` on Linux, or wherever `TKO_CLANG` points. Bundling
LLVM is a gigabyte and a separate decision.

## Status

`win64-msvc` is the default target on Windows and is verified end to end: a
packaged toolchain compiles, links and runs a program, and a graphics program
**draws** -- `point()` reads back 15 where `line` wrote colour 15, and 0 off it.
It is the default because `libtkogfx.a` is built for that ABI and no other, so it
is the only Windows target on which a `SCREEN` program links at all.

`win64`, the MinGW ABI, is also verified end to end for a non-graphics program,
and is selected with `-target win64`. Removing `libtkogfx.a` from the msvc
directory turns a graphics link into three unresolved `fb_Gfx*` externals, which
is how the archive was confirmed to be the thing satisfying them.

Each toolchain's `MANIFEST.txt` records the commit it was packaged from, and whether each
target -- and fbcunit -- passed `--verify`.

`linux-x86_64` is packaged under WSL. Its `inc/` holds the headers since 740f22cd,
and `--verify`'s program includes `containers.bi`, so a package whose headers the
compiler cannot find no longer passes. It has no graphics: a `SCREEN` program does not link there
(`fb_Gfx*` undefined).

`win32` is no longer a target and is no longer shipped. It never linked; D14 then
removed the architecture outright.
