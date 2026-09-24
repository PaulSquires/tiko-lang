# tiko-linux

The Linux x86-64 distributable toolchain. **Empty in the repository** -- every
path below is gitignored and is filled by the packaging step (see
[../README.md](../README.md)).

```
tiko-linux/
  bin/tiko                the compiler, built Release
  inc/                    the headers, searched automatically; incl. fb/, fbgfx.bi and fbcunit.bi
  include/                fbc-modern-linux's include/, copied as it is; not searched
  lib/
    linux-x86_64/         tiko-rt: libfb.a, libfbmt.a, libfbpic.a, libfbmtpic.a;
                          libfbcunit.a
    linux-x86_64-fb/      fbc's startup objects (fbrt*.o) and libfbgfx --
                          not fbc's libfb.a
  src/fbcunit/            fbcunit's source and notices -- it is LGPL, and shipped built
  licences/               the GPL and LGPL notices and the runtime's provenance
  MANIFEST.txt            what was packaged, from where, at which commit, and
                          whether the target actually compiled and ran
```

`inc/` is filled from fbc-modern-linux's `include/freebasic/`, because that
install's own `inc/` is empty. A toolchain packaged before that was fixed has an
empty `inc/`, and `#include "containers.bi"` fails there with TKO0301 unless
`-i <toolchain>/include/freebasic` is passed. Re-package it.

Neither library directory has to be named: the compiler appends both to its own
library search, ours first, as it appends `inc/` to the include search. Plain
`tiko yourprogram.bas` links, and `linux-x86_64` is the default target on Linux.

There is **no graphics library** here. libtkogfx is built for win64-msvc only, so
a `SCREEN` or `PSET` program does not link on Linux (`fb_Gfx*` undefined).

clang is found at `/usr/bin/clang`, or wherever `TKO_CLANG` points. The link uses
`ld.lld` when there is one beside clang or in `/usr/bin`, and the system `ld`
otherwise. It also needs libtinfo.

The binary sits under `bin/` rather than at the root, unlike the Windows
toolchain: that is the fbc-modern layout, and matching it is what lets the two be
swapped for one another.

Built by running `build/package.sh` **under Linux or WSL** -- a host packages
itself, because `build/build.sh` compiles the compiler for the machine it runs on.
Under WSL every default path is the Git Bash spelling, so six have to be exported:
`TKO_STAGE0`, `TKORT_FBC`, `TKORT_AR`, `TKORT_NM`, `CLANG` and `FBC_TREE`.
