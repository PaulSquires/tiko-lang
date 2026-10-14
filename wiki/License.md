# License and Attribution

## The FreeBASIC language reference in this wiki

The keyword, statement, operator, function and compiler pages of the compatibility reference are reproduced from the **FreeBASIC Wiki Manual**. The tiko pages (the language, the standard library, the toolchain and the tutorials) are not; they are covered in the next section.

> Copyright © the FreeBASIC project and wiki contributors.
> Reproduced under the [GNU Free Documentation License, Version 1.3](https://www.gnu.org/licenses/fdl-1.3.html), with **no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts**.

The upstream manual lives at <https://www.freebasic.net/wiki/DocToc>. These pages are a Markdown conversion of the official compiled manual for FreeBASIC 1.20.0; the language they describe is unchanged by this project.

## The tiko pages

These pages document the tiko language, its standard library and its toolchain. They are licensed under the **GNU Free Documentation License**.

Copyright © Paul Squires, [PlanetSquires Software](https://www.planetsquires.com).

## The compiler itself

tiko-lang is its own compiler, written from scratch in FreeBASIC. It is not a copy of fbc, and it is licensed **in parts**. The repository's `LICENSE` is the map.

| Part | Licence |
|---|---|
| The compiler (`src/`, `tools/`, `build/`, and its own `tests/`) and the `tiko` binaries built from it | **GNU GPL v2 or later** (`COPYING`) |
| The runtime, **tiko-rt** (`lib/rt/`), a derivative of fbc's `libfb` | **GNU LGPL v2.1 or later, with a static-linking exception** (`lib/rt/LICENSE`, `COPYING.LGPL-2.1`) |
| The graphics library, **libtkogfx** (`lib/gfx/`), a derivative of fbc's `gfxlib2` | **LGPL v2.1 or later, same exception** (`lib/gfx/LICENSE`) |
| tiko's documentation (`docs/`, the READMEs, and the tiko pages here) | **GNU FDL 1.3 or later** |

**Your programs are yours.** Both libraries extend fbc's static-linking exception to themselves, so a program compiled by tiko and linked against them can be distributed on any terms you choose.

**The packaged toolchains carry third-party components.**

- They redistribute fbc-modern's headers in `inc/`.
- For the `win64` and `linux-x86_64` targets they also ship fbc's own runtime binaries under `lib/<target>-fb/`: the `fbrt*.o` startup objects and `libfbgfx`. For `win64` that directory also holds libffi and the MinGW-w64 and gcc runtime libraries.
- All of it is unmodified.
- Each toolchain's `licences/` holds tiko's notices and FreeBASIC's. It holds no separate notice for the MinGW-w64, gcc or libffi archives.
- clang is not bundled.

## Where these pages came from

The FreeBASIC manual pages are a Markdown conversion of the official 1.20.0 manual, taken through the [HelpCenter](https://www.planetsquires.com/docs/) docset pipeline. The tiko pages and the manual pages are both edited here directly.
