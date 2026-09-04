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
    linux-x86_64/         libfb.a, libfbmt.a, libtkogfx.a
```

The binary sits under `bin/` rather than at the root, unlike the Windows
toolchain: that is the fbc-modern layout, and matching it is what lets the two be
swapped for one another.

Built from Windows through WSL, or natively -- both produce the same tree.
