# PROVENANCE

## The rule

**No file under `fbc-modern/src/src/rtlib/**/*.c` is ever opened by anyone
working on this repository.**

The specification is the headers, the FreeBASIC manual, and measurement.

## Why it is absolute

`libfb` is **LGPL v2.1+ with a static-linking exception**. That licence is not a
reason to rewrite anything — programs linked against `libfb` are unencumbered
already, and "keep `libfb`, honour the notices" remains a legitimate outcome of
this whole exercise.

What the licence determines is what a rewrite is *worth*. A runtime transcribed
from `libfb`'s C is a derivative work and stays LGPL permanently. A runtime
written from the ABI — interfaces and facts, which are not copyrightable — is
tiko's to license. Independence is one of the reasons this project exists; giving
it away on the first day would pay the whole cost for none of the benefit.

tiko-lang's own plan named the failure mode before this repo existed:

> **A clean-room reimplementation by someone who has read `libfb` is not a clean
> room.** If option 2 is chosen, the process matters as much as the result.

So a violation is not a bug to be fixed afterwards. **It retroactively devalues
every line written before it**, and nobody downstream can tell it happened.

## Permitted

| Source | Why |
| --- | --- |
| `fbc-modern/src/src/rtlib/**/*.h` | Interfaces, layouts, macro contracts, constants |
| `fbc-modern/src/inc/fbc-int/*.bi`, `fb/*.bi` | The same interfaces, published as the documented internal API |
| `fbc-modern/src/inc/crt/*.bi`, `windows.bi` | C library and Win32 *declarations*. See the note below |
| `fbc-modern/wiki` | The FreeBASIC manual — the behavioural specification |
| `fbc-modern/src/tests/**` | fbc's test suite. Tests state required behaviour |
| `nm` / `objdump` / `ar` over the shipped archives | Measured facts about a binary |
| **Probes** — a program compiled with `fbc` and run | The project's method for every compatibility fact |

## Forbidden

| Source | Note |
| --- | --- |
| `fbc-modern/src/src/rtlib/**/*.c` | The rule |
| Any `-r` / `.i` / preprocessed C derived from one | Same content, one step removed |
| `fbc-modern/src/src/compiler/**` | Separately forbidden — the **compiler** is GPL v2+, not LGPL. Two different rules, both in force |
| Any third-party FreeBASIC runtime reimplementation | The same reasoning applies to anyone's expression |

### Note on the crt bindings

61 of the 80 headers under `fbc-modern/src/inc/crt/` carry:

> NOTICE: This file is part of the FreeBASIC Compiler package and can't be
> included in other distributions without authorization.

tiko-rt **includes** them from an fbc-modern install, which its build already
requires. It does **not** vendor or redistribute them, and must not start.
Owning these bindings — generating them from the *system* headers with
`-cimport` — is a named work item for the full port, not a spike blocker. See
`src/sys/sys.bi`.

## How a behaviour gets established

1. Read the entry point's declaration and contract in the header.
2. Read what the manual says the construct does.
3. **Write a probe.** Compile it with `fbc`, run it, read the answer.
4. Write the test first, then the implementation, then make the test pass.
5. If probe and header disagree, the probe wins and the document gets fixed.

**If you cannot write a probe that establishes a behaviour, you do not yet know
that behaviour.**

## Enforcement

`build/lint.sh` fails the build on a C file outside `src/c/`, a file in `src/c/`
missing from its `README.md`, or a source that cites an `rtlib/*.c` path. Those
catch the cheap case. The rest is discipline.

## If the rule costs too much

It might — `str_format`'s `PRINT USING` grammar is the likeliest place. That is a
**spike finding, not a licence to improvise**: report that R2 could not be held,
say where and why, and re-open the decision with evidence. The honest outcomes
are then "accept the derivation and the LGPL", "keep that subsystem in C", or
"no-go". What must not happen is a quiet violation.

Full reasoning: [`docs/tiko-rt/RFC-0005`](../docs/tiko-rt/RFC-0005-provenance.md).
