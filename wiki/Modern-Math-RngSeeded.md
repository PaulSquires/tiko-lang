[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RngSeeded**

# RngSeeded

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A generator seeded with a value you choose, so the sequence repeats.

## Syntax

```freebasic
RngSeeded( byval seed as ulongint ) as Rng
```

## Notes

- **Reproducible**: the same seed gives the same sequence on every run and every platform, which is what a test needs.
- `RngFromEntropy` is the other constructor, seeded from the OS and therefore different every run.
- Not cryptographically secure -- knowing a few outputs reveals the state. `CryptoBytes` is the one for keys and tokens.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim as ulongint seed = 12345
dim a as Rng = RngSeeded( seed )
dim b as Rng = RngSeeded( seed )

'' The same seed gives the same sequence -- which is what makes a test
'' with random input reproducible
dim as longint lo = 1, hi = 1000000
print a.NextInt( lo, hi ) = b.NextInt( lo, hi )      '' -1 (true)
print a.NextInt( lo, hi ) = b.NextInt( lo, hi )      '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
