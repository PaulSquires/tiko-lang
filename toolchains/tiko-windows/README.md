# tiko-windows

The Windows x86-64 distributable toolchain. **Empty in the repository** -- every
path below is gitignored and is filled by the packaging step (see
[../README.md](../README.md)).

```
tiko-windows/
  tiko.exe                the compiler, built Release
  bin/                    as.exe, ld.exe, ar.exe and the rest of binutils
  inc/                    headers reachable by -i, incl. fb/ and fbgfx.bi
  lib/
    win64/                libfb.a, libfbmt.a, libtkogfx.a, the import libraries
    win32/                the same, for -target win32
```

`lib/win32/` is present because the compiler accepts `-target win32` and the
runtime already builds for it; a toolchain that shipped only `win64` would make
that flag fail at link time rather than at the point it was passed.
