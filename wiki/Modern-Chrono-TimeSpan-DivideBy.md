[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.DivideBy**

# TimeSpan.DivideBy

double; NaN on zero or Invalid

## Syntax

```freebasic
TimeSpan.DivideBy( other )
```

## Notes

- double; NaN on zero or Invalid

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan a = TimeSpan( 1, 0, 0 )
dim as TimeSpan b = TimeSpan( 0, 30, 0 )

'' Span divided by span is a plain DOUBLE -- a ratio, not a duration
print a.DivideBy( b )        '' 2

'' "How many of b fit in a", which is what makes it different from
'' Divide( f ), whose result is still a TimeSpan
print b.DivideBy( a )        '' 0.5

'' Dividing by a zero span gives NaN, and NaN is not equal to itself
dim as float64 r = a.DivideBy( TimeSpan.Zero( ) )
print ( r <> r )             '' -1 (true), i.e. NaN
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
