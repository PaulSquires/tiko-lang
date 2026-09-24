[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextBooleanP**

# NextBooleanP

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NextBooleanP( p )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

'' TRUE with probability p
print r.NextBooleanP( 1.0 )  '' true -- certain
print r.NextBooleanP( 0.0 )  '' false -- never

dim as long hits = 0
for i as long = 1 to 1000
    if r.NextBooleanP( 0.5 ) then hits += 1
next
print hits > 350 andalso hits < 650       '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
