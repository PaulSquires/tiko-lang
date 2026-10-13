# lib/implib -- windows-x86_64's import libraries, as source

`build/package.sh` turns these into `lib/windows-x86_64/*.lib` in a toolchain with
`build/implibs.sh build`: one `llvm-dlltool` run per `.def`, and `static/*.lib` copied
through. Nothing outside this directory is read, so the default target's import
libraries need no fbc and no MinGW tree.

- `*.def` -- 827 DLLs, one export list each. The code/data split was decided once, on
  the machine `EXPORTED.txt` names, by `build/mkmsvcdef.py` (it consults System32).
- `static/*.lib` -- 16 archives with no DLL behind them: GUID and other data objects
  (`uuid`, `dxguid`, `strmiids`, ...).
- `EXPORTED.txt` -- inputs, machine and counts of the export.

Measured 2026-10-10: `build` reproduced all 843 libraries of the toolchain that
`mkmsvcimplibs.sh` had generated, byte for byte.

**Local additions**, kept by hand -- a re-export must keep them: `strnlen` in `ucrtbase.def`
and `ucrt.def` (2026-10-13). mingw-w64 leaves it out because its libmingwex supplies one; tiko
links no libmingwex, so a Visual C++ static library that calls it (SDL3's) could not link.

**A new Windows library**: write its `.def` by hand, or run
`build/implibs.sh export --from <dir of lib*.dll.a>` again and read the diff.

Derived from mingw-w64's import libraries -- ZPL 2.1, with parts in the public domain;
see `COPYING.MinGW-w64-runtime.txt`, which ships with them.
