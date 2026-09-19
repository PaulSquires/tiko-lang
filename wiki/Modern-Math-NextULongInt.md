[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextULongInt**

# NextULongInt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A uniformly random 64-bit value.

## Syntax

```freebasic
NextULongInt( ) as ulongint
```

## Notes

- The **raw generator output**: every bit is random, and every one of the 2^64 values is equally likely.
- This is what the other Next* members are built from -- `NextDouble` takes 53 bits of it, `NextInt` rejects and retries to stay unbiased.
- Not secure. `CryptoULongInt` is the equivalent from the OS entropy source.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as ulongint a = r.NextULongInt( )
dim as ulongint b = r.NextULongInt( )

print a <> b                 '' -1 (true), with overwhelming probability

'' Do NOT reduce it with MOD to get a range -- that biases the low end.
'' NextInt rejects and retries instead.
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
