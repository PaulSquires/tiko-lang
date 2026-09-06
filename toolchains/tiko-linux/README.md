# tiko-linux

The Linux x86-64 distributable toolchain. **Empty in the repository** -- every
path below is gitignored and is filled by the packaging step (see
[../README.md](../README.md)).

```
tiko-linux/
  bin/tiko                the compiler, built Release
  inc/                    headers reachable by -i, incl. fb/ and fbgfx.bi
  include/                the C headers the runtime's bindings need
  lib/
    linux-x86_64/         tiko-rt: libfb.a, libfbmt.a (+ libtkogfx.a when it exists)
    linux-x86_64-fb/      fbc's libfb.a and the support libraries
  licences/               the LGPL notices and the runtime's provenance
  MANIFEST.txt            what was packaged, from where, at which commit, and
                          whether the target actually compiled and ran
```

Neither directory has to be named: the compiler appends both to its own library
search, ours first, as it appends `inc/` to the include search. Plain
`tiko -target linux-x86_64 yourprogram.bas` links.

The binary sits under `bin/` rather than at the root, unlike the Windows
toolchain: that is the fbc-modern layout, and matching it is what lets the two be
swapped for one another.

Built by running `build/package.sh` **under Linux or WSL** -- a host packages
itself, because `build/build.sh` compiles the compiler for the machine it runs on.

**This has never been packaged.** Everything above is the intended layout, not a
measured one.
