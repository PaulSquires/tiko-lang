# tiko-windows

The Windows x86-64 distributable toolchain. **Empty in the repository** -- every
path below is gitignored and is filled by the packaging step (see
[../README.md](../README.md)).

```
tiko-windows/
  tiko.exe                the compiler, built Release
  inc/                    headers reachable by -i, incl. fb/ and fbgfx.bi
  lib/
    win64/                tiko-rt: libfb.a, libfbmt.a
    win64-fb/             fbc's libfb.a, the CRT objects, the import libraries
    win64-msvc/           tiko-rt AND libtkogfx.a, for -target win64-msvc;
                          no -fb pair, and none needed
  licences/               the LGPL notices and the runtime's provenance
  MANIFEST.txt            what was packaged, from where, at which commit, and
                          whether each target actually compiled and ran
```

The compiler finds `inc/` on its own: it looks at `<exe-dir>/inc` and then
`<exe-dir>/../inc`, which is why the binary sits at the root here and under
`bin/` in the Linux toolchain.

`lib/win32*` is gone. D14 made x86-64 the only architecture, so `-target win32`
no longer exists to ship for -- and while the packaging script still asked for it,
it died on the missing runtime and produced no toolchain at all.

`lib/win64-msvc/` is the graphics target. `lib/gfx` builds for the Microsoft ABI
and nothing else, so `libtkogfx.a` appears there and only there; a program using
`screenres` or `line` links with `-target win64-msvc` and not otherwise. It is
also the one target with no `-fb` directory: fbc has no MSVC target so there is
nothing to copy, and measurement says nothing is wanted -- a program linked
against `lib/win64-msvc/` alone runs.

Neither directory has to be named. The compiler appends `<exe-dir>/lib/<target>`
and then `<exe-dir>/lib/<target>-fb` to its own library search -- ours first, so a
single `-l` resolves out of tiko-rt before it reaches fbc's -- exactly as it appends
`<exe-dir>/inc` to the include search. `tiko -target win64 yourprogram.bas` links.

A `-p` of your own is searched before both, and `TKO_LIBPATH` replaces them.
