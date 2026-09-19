[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextBoolean**

# NextBoolean

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

TRUE or FALSE with equal probability.

## Syntax

```freebasic
NextBoolean( ) as boolean
```

## Notes

- One bit of the generator, not a comparison against 0.5 -- so it costs nothing extra and cannot be skewed by floating point.
- `NextBooleanP` is the weighted version.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as long hits = 0
for i as long = 1 to 1000
    if r.NextBoolean( ) then hits += 1
next

print hits > 400 andalso hits < 600           '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
