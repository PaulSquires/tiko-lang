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

The layout deliberately mirrors `C:\dev\fbc-modern\toolchains\`, so a tiko
toolchain can be dropped in wherever an fbc-modern one is expected and the
`-i` / `-l` search paths resolve unchanged.

## Where each part comes from

| Part | Produced by |
| --- | --- |
| the compiler binary | `build/build.sh Release` -> `bin/tiko[.exe]` |
| `lib/<target>/libfb.a`, `libfbmt.a` | `lib/rt/build/build.sh Release` -> `lib/rt/lib/<target>/` |
| `lib/<target>/libtkogfx.a` | `lib/gfx/build/build.sh Release win64-msvc` -> `lib/gfx/lib/win64-msvc/`; that is the only target it builds |
| `lib/<target>-fb/` | copied from the reference fbc toolchain: its `libfb.a`, the CRT objects, the import libraries |
| `inc/`, `include/` | copied from the reference fbc toolchain; tiko ships no headers of its own yet |

## Building one

```bash
build/package.sh --verify
```

Builds the compiler, the runtime **and the graphics library** at `Release`,
assembles the tree for the
current host, then compiles **and runs** a program per target and records the
result in `MANIFEST.txt`. `--no-build` packages what is already built, `--no-inc`
skips the ~100 MB header copy, `--clean` empties the output first, and `--help`
lists the rest.

A host packages itself -- `tiko-linux` comes from running it under Linux or WSL.

The contents are gitignored, so a fresh clone has the two directories and these
READMEs and nothing else.

## Two directories per target

`lib/<target>/` is tiko-rt's runtime and `lib/<target>-fb/` is fbc's, and a link
needs **both, ours first**. It gets them without being asked: the compiler appends
both to its library search relative to its own executable, the way it appends
`inc/` to the include search and the way fbc appends `lib/<target>` to its own.

```bash
tiko -target win64 yourprogram.bas
```

A `-p` is searched first and overrides either; `TKO_LIBPATH` replaces both.

tiko-rt is partial -- its thread layer references `fb_AtomicCasLong`, which only
fbc's `libfb` defines. A single `-l` resolves once, from the first path that has
the archive, which is why the compiler names each library path's `libfb.a` as a
file and why one directory would not do.

## Not self-contained

**clang is required and not bundled.** The compiler runs it for both the `.ll` to
`.o` step and the link; it is looked for at `C:\Program Files\LLVM\bin`, or wherever
`TKO_CLANG` points. Bundling LLVM is a gigabyte and a separate decision.

## Status

`win64-msvc` is the default target on Windows and is verified end to end: a
packaged toolchain compiles, links and runs a program, and a graphics program
**draws** -- `point()` reads back 15 where `line` wrote colour 15, and 0 off it.
It is the default because `libtkogfx.a` is built for that ABI and no other, so it
is the only Windows target on which a `SCREEN` program links at all.

`win64`, the MinGW ABI, is also verified end to end for a non-graphics program
(`--verify`, 2026-09-06) and is selected with `-target win64`. Removing
`libtkogfx.a` from the msvc directory turns a graphics link into three unresolved
`fb_Gfx*` externals, which is how the archive was confirmed to be the thing
satisfying them.

`win32` is no longer a target and is no longer shipped. It never linked; D14 then
removed the architecture outright.

`tiko-linux` has never been packaged; it needs a run under WSL.
