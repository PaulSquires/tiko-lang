# Derive probes -- RFC 0019's baseline

These probes pin what RFC 0019 ("Compile-time reflection: derived members and enum names",
`docs/architecture/decisions/0019-reflection.md`, local) promises, **before any of it exists**.
Each phase can then show what it changed and what it did not.

| File | What it pins | Changes in |
| --- | --- | --- |
| `hashes.tiko` | Every built-in hash std/containers computes today: `HashInt`, `HashBytes`, and each `HashOf` overload, over fixed inputs. R5 moves them into the runtime **with the same values**. | **never** |
| `eqorder.tiko` | The **oracle** for `derive equal, order` (R2, R3): the operators written by hand, following the rule in its header. It prints truth tables for `Plain` and `Mixed` (a base, a float, a string, a ustring, a fixed and a dynamic array, a nested type, an enum and a pointer). | never; P1/P2 add a derived twin that must print the same |
| `hashkey.tiko` | The **oracle** for `derive hash` (R4): the fold `h = HashInt( h ) xor <field hash>`, written by hand. It also checks that this is book ch24's hand-written `Cell` hash, and that `Map` finds equal keys, `-0.0` included. | never; P1 adds a derived twin with no `Hashable` |
| `text.tiko` | The **oracle** for `derive text` (R6): `ToText( ) as ustring`, written by hand, in the section 5.3 format, edge cases included. | never; P2 adds a derived twin |
| `enums.bas` | The **oracle** for R9: `enumname`, `enumcount` and `enumvalue` as `select case` and tables. It covers negative values, duplicate values (the first declared wins), an `explicit` enum and an enum in a namespace. Plain FreeBASIC. | never; P3 adds a twin using the intrinsics |
| `contextual.bas` | Every name the record adds, used as an ordinary FreeBASIC name: a field and a sub called `derive`, the paren-less call `derive equal` outside a type, user `enumname` / `enumcount`, locals `enumvalue` / `hashvalue`, a hand-written `ToText`, and enum constants `derive` ... `text`. Plain FreeBASIC. | **never** |
| `syntax.tiko` | A `derive` line and the four intrinsics. Rejected today, so its baseline is the diagnostics. | P1 (`derive`, `hashvalue`), P2 (`ToText`), P3 (enums) |

`TIKO-ONLY` in a header means the file uses a tiko extension (`#import`, `int32`), so it has
no `.fbc-trace`.

## Running

```
bash build/derivetrace.sh                  # windows-x86_64: build + run, diff against the latest .pN-trace
bash build/derivetrace.sh --linux          # linux-x86_64: cross-compiled, linked and run in WSL
bash build/derivetrace.sh --record pN      # write .pN-trace (and, for p0, .fbc-trace)
bash build/derivetrace.sh --linux --record pN   # write .linux.pN-trace only where Linux differs
```

## P0, recorded 2026-11-27 (tiko 0.1.8, bin/tiko.exe of 20:26)

**Which compiler.** `bin/tiko.exe` was built at 20:26 on branch `feat/move-semantics-p0`
(`1315efe82`: RFC 0018 P0 on top of master `61a0e6813`) PLUS another
session's uncommitted RFC 0018 P1 work (`src/mir/lower*.tiko`). It was not a clean master. None
of these probes counts structors: they print values, so P1's moves should not change them.
That is an argument, not a measurement. Re-run `bash build/derivetrace.sh` on a clean
master build before P1 starts; it should report 7 same.

- **Windows:** 7 probes recorded. `contextual` and `enums` print **the same under tiko and
  fbc 1.20**.
- **Linux (WSL):** 6 of 7 print exactly the Windows trace. `hashes` differs in **one row
  only**, `wstring ptr abc`, as predicted: a WSTRING is 4 bytes on Linux. That row is the
  only reason `hashes.linux.p0-trace` exists.
- **macOS arm64:** not run. The Mac runs at milestones, not at P0.

## Found while recording

- **A STRING hashes up to its first NUL.** `containers.HashOf( s )` with `s` a STRING
  resolves to the `const zstring ptr` overload, not `byref const string`. fbc 1.20 resolves
  it the same way, measured with a two-overload probe, so this is FreeBASIC's rule and not a
  tiko bug. `chr( 0 ) & "x"` therefore hashes like `""`. That is a collision, not a wrong
  answer: `=` still tells the two apart. R5 keeps every value, so it keeps this too. A
  derived hash of a STRING field gets the same value, because it uses the built-in hash.
- **`redim m( i ).dyn( ... )` is rejected by both compilers** (tiko TKO0723, fbc error 54).
  The spelling that works in both is `redim ( m( i ).dyn )( ... )`. This is not new; it is
  recorded here because the probes need it.
