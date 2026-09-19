[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextExponential**

# NextExponential

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NextExponential( lambda )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

'' The waiting time between events arriving at rate lambda. Its mean is
'' 1/lambda, so a bigger lambda gives shorter gaps.
dim as double total = 0
for i as long = 1 to 2000
    total += r.NextExponential( 2.0 )
next
dim as double mean_ = total / 2000

print mean_ > 0.35 andalso mean_ < 0.65   '' -1 (true), around 0.5
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
