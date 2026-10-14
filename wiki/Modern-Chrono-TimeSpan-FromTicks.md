[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromTicks**

# TimeSpan.FromTicks

## Syntax

```freebasic
TimeSpan.FromTicks( int64 )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' The tick is 100 ns, and is the unit everything here measures in
print TimeSpan.FromTicks( 10000000ll ).TotalSeconds     '' 1

'' Exact, with no rounding step at all -- the other From* functions
'' convert a double and round half away from zero to get here
print TimeSpan.FromTicks( 1 ).Ticks              '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
