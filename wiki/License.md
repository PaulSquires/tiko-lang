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

tiko-lang is a modified copy of the FreeBASIC compiler, so it carries FreeBASIC's licensing **unchanged**. Nothing is relicensed and no licence was chosen — it is inherited, and it is a split, because the work touches both halves.

| Part | Licence |
|---|---|
| The compiler — `src/src/compiler/`, and the binaries built from it | **GNU GPL v2 or later** (`COPYING.GPL-2.0`) |
| The runtime and graphics libraries — `src/src/rtlib/`, `src/src/gfxlib2/` | **GNU LGPL v2.1 or later, with a static-linking exception** (`COPYING.LGPL-2.1`) |
| The container headers — `src/inc/fb/*.bi`, `src/inc/containers.bi` | **LGPL v2.1 or later, same exception** — they compile into your program, so they are runtime, not compiler |
| Documentation under `docs/` | **GNU FDL** |

The linking exception is what lets a program link the runtime statically without taking on the LGPL; it is quoted in full in the repository's `LICENSE`.

**The prebuilt trees carry third-party components.** `toolchains/` redistributes the toolchain fbc invokes — GNU binutils and gcc under **GPLv3**, plus the MinGW-w64 runtime and import libraries under their own terms. They are unmodified redistributions.

## Where these pages came from

The FreeBASIC manual pages are a Markdown conversion of the official 1.20.0 manual, taken through the [HelpCenter](https://www.planetsquires.com/docs/) docset pipeline. The ✨ pages began as the tiko-lang feature documentation under `docs/` in the repository. Both are edited here directly.
