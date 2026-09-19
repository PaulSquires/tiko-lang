# License and Attribution

## The FreeBASIC language reference in this wiki

Every page in this wiki that is **not** marked ✨ / *tiko-lang extension* is reproduced from the **FreeBASIC Wiki Manual**.

> Copyright © the FreeBASIC project and wiki contributors.
> Reproduced under the [GNU Free Documentation License, Version 1.3](https://www.gnu.org/licenses/fdl-1.3.html), with **no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts**.

The upstream manual lives at <https://www.freebasic.net/wiki/DocToc>. These pages are a Markdown conversion of the official compiled manual for FreeBASIC 1.20.0; the language they describe is unchanged by this project.

## The tiko-lang pages

Pages marked ✨ document features added by tiko-lang. They share their text with the documentation in the [tiko-lang repository](https://github.com/PaulSquires/tiko-lang) under `docs/`, which is licensed under the **GNU Free Documentation License**.

Copyright © Paul Squires, [PlanetSquires Software](https://www.planetsquires.com).

## The compiler itself

tiko-lang is its own compiler, written from scratch in FreeBASIC. It is not a copy of fbc, and it is licensed **in parts**. The repository's `LICENSE` is the map.

| Part | Licence |
|---|---|
| The compiler (`src/`, `tools/`, `build/`, and its own `tests/`) and the `tiko` binaries built from it | **GNU GPL v2 or later** (`COPYING`) |
| The runtime, **tiko-rt** (`lib/rt/`), a derivative of fbc's `libfb` | **GNU LGPL v2.1 or later, with a static-linking exception** (`lib/rt/LICENSE`, `COPYING.LGPL-2.1`) |
| The graphics library, **libtkogfx** (`lib/gfx/`), a derivative of fbc's `gfxlib2` | **LGPL v2.1 or later, same exception** (`lib/gfx/LICENSE`) |
| tiko's documentation (`docs/`, the READMEs, and the ✨ pages here) | **GNU FDL 1.3 or later** |

**Your programs are yours.** Both libraries extend fbc's static-linking exception to themselves, so a program compiled by tiko and linked against them can be distributed on any terms you choose, just as a program built with fbc can.

**The prebuilt toolchains carry third-party components.** They redistribute fbc-modern's `inc/` headers. For the `win64` and `linux-x86_64` targets they also ship fbc's own runtime binaries, and for `win64` libffi and the MinGW-w64 and gcc runtime libraries. All of it is unmodified, and the notices are in each toolchain's `licences/`. clang is not bundled.

## Where these pages came from

The FreeBASIC manual pages are a Markdown conversion of the official 1.20.0 manual, taken through the [HelpCenter](https://www.planetsquires.com/docs/) docset pipeline. The ✨ pages began as the tiko-lang feature documentation under `docs/` in the repository. Both are edited here directly.
