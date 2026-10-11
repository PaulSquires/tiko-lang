[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.FromMicroseconds**

# TimeSpan.FromMicroseconds

longint, not double

## Syntax

```freebasic
TimeSpan.FromMicroseconds( int64 )
```

## Notes

- longint, not double

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan.FromMicroseconds( 1000000 ).TotalSeconds      '' 1

'' Takes a LONGINT, not a double like the other From* functions: at
'' microsecond resolution a double would start losing whole ticks
print TimeSpan.FromMicroseconds( 1 ).Ticks       '' 10 -- ten 100 ns ticks
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
