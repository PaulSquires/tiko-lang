# tiko-windows

The Windows x86-64 distributable toolchain. **Empty in the repository** -- every
path below is gitignored and is filled by the packaging step (see
[../README.md](../README.md)).

```
tiko-windows/
  tiko.exe                the compiler, built Release
  inc/                    headers reachable by -i, incl. fb/ and fbgfx.bi
  lib/
    win64/                tiko-rt: libfb.a, libfbmt.a (+ libtkogfx.a when it exists)
    win64-fb/             fbc's libfb.a, the CRT objects, the import libraries
    win32/    win32-fb/   the same pair, for -target win32
  licences/               the LGPL notices and the runtime's provenance
  MANIFEST.txt            what was packaged, from where, at which commit, and
                          whether each target actually compiled and ran
```

The compiler finds `inc/` on its own: it looks at `<exe-dir>/inc` and then
`<exe-dir>/../inc`, which is why the binary sits at the root here and under
`bin/` in the Linux toolchain.

`lib/win32*` is present because the compiler accepts `-target win32` and the
runtime builds for it; a toolchain that shipped only `win64` would make that flag
fail at link time rather than at the point it was passed. **It does not link
today** -- see the parent README.

Both directories of a pair are passed, ours first:
`tiko -target win64 -p lib/win64 -p lib/win64-fb`.
