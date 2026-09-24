[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextPoisson**

# NextPoisson

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NextPoisson( lambda )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

'' How many events arrive in one interval at rate lambda. Its mean IS
'' lambda, and it is a count, so it never comes back negative.
dim as longint total = 0
for i as long = 1 to 2000
    total += r.NextPoisson( 4.0 )
next
dim as double mean_ = total / 2000

print mean_ > 3.5 andalso mean_ < 4.5     '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
