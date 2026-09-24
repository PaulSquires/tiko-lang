[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextNormalP**

# NextNormalP

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NextNormalP( mean, sd )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

'' Gaussian with a given mean and standard deviation
dim as double total = 0
for i as long = 1 to 2000
    total += r.NextNormalP( 100.0, 15.0 )
next
dim as double mean_ = total / 2000

print mean_ > 95 andalso mean_ < 105      '' -1 (true)

'' NextNormal( ) is the standard one -- mean 0, sd 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
