# toolchains

The **distributable** builds of tiko: what an end user downloads and unpacks, as
opposed to `bin/tiko.exe`, which is what `build/build.sh` produces for developing
the compiler itself.

One directory per host platform:

| Directory | Host | Ships |
| --- | --- | --- |
| `tiko-windows/` | Windows x86-64 | `tiko.exe`, `bin/` (binutils), `inc/`, `lib/win64/`, `lib/win32/` |
| `tiko-linux/`   | Linux x86-64   | `bin/tiko`, `inc/`, `include/`, `lib/linux-x86_64/` |

The layout deliberately mirrors `C:\dev\fbc-modern\toolchains\`, so a tiko
toolchain can be dropped in wherever an fbc-modern one is expected and the
`-i` / `-l` search paths resolve unchanged.

## Where each part comes from

| Part | Produced by |
| --- | --- |
| the compiler binary | `build/build.sh Release` -> `bin/tiko[.exe]` |
| `lib/<target>/libfb.a`, `libfbmt.a` | `lib/rt/build/build.sh Release` -> `lib/rt/lib/<target>/` |
| `lib/<target>/libtkogfx.a` | `lib/gfx` (not yet built -- see `lib/gfx/README.md`) |
| `inc/` | the header set the runtime and graphics libraries expose |
| `bin/` (Windows) | binutils: `as`, `ld`, `ar`, and the MinGW import libraries |

## Status

**The tree is a placeholder. Nothing populates it yet** -- there is no packaging
script, and the contents of both directories are gitignored, so a fresh clone has
the two empty directories and these READMEs and nothing else. Assembling a
toolchain today means copying the four parts above by hand.

Two things must be true before a packaging script is worth writing: the graphics
library has to produce an archive at all, and the Release configuration of both
the compiler and the runtime has to be the one that is gated, not merely the one
that builds.
