# inc/ -- provenance

Imported 2026-10-10 by tiko-bootstrap's scripts/import-headers.sh. From this
commit on, tiko-lang is the upstream of every file listed as core, and the vendor of every
file listed as lang. Nothing here is copied from fbc-modern again.

| Source | Path | Commit |
|---|---|---|
| fbc-modern headers | `/c/dev/fbc-modern/src/inc` | 78a85df43a17 |
| fbc-modern shipped toolchain headers | `/c/dev/fbc-modern/toolchains/fbc-modern-windows/inc` | (same repository) |
| upstream FreeBASIC 1.20.0, for classification only | `C:\dev\utils\fbc-master\inc` | (a copy in the C:\dev workspace; no commit of its own) |

| Tier | Files | Rule |
|---|---|---|
| core | 77 | in fbc-modern's src/inc, not in upstream FreeBASIC -- fbc-modern's own work; tiko-lang is upstream now |
| core-modified | 3 | upstream files fbc-modern changed (compared ignoring CR) |
| lang | 613 | FreeBASIC's headers as fbc-modern's toolchain ships them, incl. its win/ overlays, plus GL/ |
| third | 3530 | NOT imported: SDL, GTK, Lua, AfxNova and the rest. build/package.sh still copies them from fbc-modern's toolchain, under this tree's files, until the author decides where they live |

Licences: core and core-modified are LGPL-2.1-or-later with the FreeBASIC static-linking
exception (fbc-modern LICENSE, lines 72-77: "Upstream's own inc/ headers carry no per-file
notice, so this is stated here rather than inherited"). lang carries FreeBASIC's own terms,
including 146 files with a no-redistribution notice for which the author holds the FreeBASIC
project's permission.

Every file was copied with its line endings made LF (a CR ending a line dropped), and
nothing else changed. .import-manifest.tsv has the sha256 of each file
as written here.

## Decisions, 2026-10-10 (the author's)

- **LF.** The files are tiko-lang's convention, LF; fbc-modern's Windows toolchain had them
  CRLF and its Linux toolchain LF, with the same content. Both hosts already compiled LF.
- **The no-redistribution headers are committed.** The FreeBASIC project's permission
  covers shipping them in every toolchain release; tiko-lang is a private repository at
  this commit. Revisit before it is made public.
- **Third-party bindings stay out** (the third tier above).

The plan behind this, and how each consumer was switched over, is in C:\dev\tiko-bootstrap
(docs/HEADERS.md).

## Local changes

A **core** header is tiko-lang's own now: change it here, with a test, like any source.
A **lang** header is changed only to fix a binding, and every such change is listed below
so a later re-vendor of FreeBASIC's set knows what to keep.

(none yet)
