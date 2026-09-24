[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Shuffle**

# Shuffle

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Shuffle( r, a( ) )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )
dim as long a( 0 to 4 ) = { 1, 2, 3, 4, 5 }

'' Fisher-Yates, in place and unbiased -- every permutation equally
'' likely, which the sort-by-random-key trick does not give
Shuffle( r, a( ) )

dim as long total = 0
for i as long = 0 to 4
    total += a( i )
next
print total                  '' 15 -- the same elements, reordered
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
