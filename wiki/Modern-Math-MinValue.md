[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinValue**

# MinValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The smallest value added to a running accumulator.

## Syntax

```freebasic
RunningStats.MinValue( ) as double
```

## Notes

- Tracked as values arrive, so it costs one comparison per `Add` rather than a second pass.
- `MinOf` is the array equivalent.
- On an empty accumulator it reads as 0.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim rs as RunningStats
for i as long = 1 to 5 : rs.Add( i ) : next

print rs.MinValue( )         '' 1
print rs.MaxValue( )         '' 5
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
