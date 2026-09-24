# tiko-windows

The Windows x86-64 distributable toolchain. **Empty in the repository** -- every
path below is gitignored and is filled by the packaging step (see
[../README.md](../README.md)).

```
tiko-windows/
  tiko.exe                the compiler
  inc/                    the headers, searched automatically; incl. fb/, fbgfx.bi and fbcunit.bi
  lib/
    win64-msvc/           THE DEFAULT: tiko-rt, libtkogfx.a, libfbcunit.a and the
                          generated MSVC import libraries (*.lib); no -fb pair, and none needed
    win64/                tiko-rt: libfb.a, libfbmt.a; libfbcunit.a
    win64-fb/             fbc's CRT and startup objects, libfbgfx, the MinGW
                          import libraries -- not fbc's libfb.a
  src/fbcunit/            fbcunit's source and notices -- it is LGPL, and shipped built
  licences/               the GPL and LGPL notices and the runtime's provenance
  MANIFEST.txt            what was packaged, from where, at which commit, and
                          whether each target actually compiled and ran
```

The compiler finds `inc/` on its own: it looks at `<exe-dir>/inc` and then
`<exe-dir>/../inc`, which is why the binary sits at the root here and under
`bin/` in the Linux toolchain.

`lib/win32*` is gone. D14 made x86-64 the only architecture, so `-target win32`
no longer exists to ship for -- and while the packaging script still asked for it,
it died on the missing runtime and produced no toolchain at all.

`lib/win64-msvc/` is **the default**, and holds the graphics library. `lib/gfx`
builds for the Microsoft ABI and nothing else, so `libtkogfx.a` appears there and
only there -- which is why that target is the default rather than an option: with
`win64` as the default, `tiko test.bas` on a `SCREEN` program answered `undefined
reference to fb_GfxScreen` and the fix was a flag the user had to know about.

It is also the one target with no `-fb` directory: fbc has no MSVC target so there
is nothing to copy, and measurement says nothing is wanted -- a program linked
against `lib/win64-msvc/` alone links, runs, and draws (`point()` reads back the
colour that `line` wrote). Its `*.lib` files are MSVC-format import libraries,
generated from fbc's MinGW `lib<name>.dll.a` by `build/mkmsvcimplibs.sh`, so that
the link does not fall back on an installed Visual Studio's.

`-target win64` still selects the MinGW ABI, with `lib/win64` and `lib/win64-fb`
behind it. It has no graphics.

Neither directory has to be named. The compiler appends `<exe-dir>/lib/<target>`
and then `<exe-dir>/lib/<target>-fb` to its own library search, ours first --
exactly as it appends `<exe-dir>/inc` to the include search. tiko-rt is the whole
runtime (decision 0015), and the `-fb` directory supplies only what a MinGW link
needs from fbc's toolchain besides one. `tiko -target win64 yourprogram.bas` links.

A `-p` of your own is searched before both, and `TKO_LIBPATH` replaces them.
