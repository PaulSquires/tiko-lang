[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextSingle**

# NextSingle

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A single in [0, 1).

## Syntax

```freebasic
NextSingle( ) as single
```

## Notes

- The single-precision counterpart of `NextDouble`, with 24 bits of randomness rather than 53.
- Half-open, on the same rule.
- Use it when the value feeds single-precision arithmetic anyway; there is no accuracy to gain from the wider draw.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as single v = r.NextSingle( )
print v >= 0.0 andalso v < 1.0                '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
