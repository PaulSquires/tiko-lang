[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextULong**

# NextULong

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A uniformly random 32-bit value.

## Syntax

```freebasic
NextULong( ) as ulong
```

## Notes

- The top 32 bits of a 64-bit draw, so it costs the same as `NextULongInt`.
- Every one of the 2^32 values is equally likely.
- Like the rest of the Rng, not secure.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as ulong a = r.NextULong( )
dim as ulong b = r.NextULong( )

print a <> b                 '' -1 (true), almost always
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
