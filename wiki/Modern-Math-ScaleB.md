[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ScaleB**

# ScaleB

Multiplies a number by a power of two exactly, by adjusting its exponent.

## Syntax

```freebasic
ScaleB( byval x as float64, byval n as int32 ) as float64
```

## Notes

- `x * 2 ^ n` computed by **adjusting the exponent**, so it is exact and cannot lose precision the way multiplying by a computed power can.
- It also survives an intermediate that would overflow: `2 ^ 1000` is an infinity, but scaling by 1000 and back is not.
- The inverse partner of `Frexp`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print ScaleB( 1.0, 10 )      '' 1024
print ScaleB( 3.0, -1 )      '' 1.5

'' Exact, and no intermediate to overflow
print ScaleB( ScaleB( 1.0, 1000 ), -1000 )    '' 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
