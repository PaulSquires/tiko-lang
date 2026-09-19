[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MaxValue**

# MaxValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The largest value added to a running accumulator.

## Syntax

```freebasic
RunningStats.MaxValue( ) as double
```

## Notes

- Tracked incrementally, like `MinValue`.
- `MaxOf` is the array equivalent.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim rs as RunningStats
for i as long = 1 to 5 : rs.Add( i ) : next

print rs.MaxValue( )         '' 5
print rs.MaxValue( ) - rs.MinValue( )         '' 4
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
