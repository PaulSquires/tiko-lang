[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ScaleB**

# ScaleB

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Multiplies by a power of two, exactly and without overflow in the exponent.

## Syntax

```freebasic
ScaleB( byval x as double, byval n as long ) as double
```

## Notes

- `x * 2 ^ n` computed by **adjusting the exponent**, so it is exact and cannot lose precision the way multiplying by a computed power can.
- It also survives an intermediate that would overflow: `2 ^ 1000` is an infinity, but scaling by 1000 and back is not.
- The inverse partner of `Frexp`.

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print ScaleB( 1.0, 10 )      '' 1024
print ScaleB( 3.0, -1 )      '' 1.5

'' Exact, and no intermediate to overflow
print ScaleB( ScaleB( 1.0, 1000 ), -1000 )    '' 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
