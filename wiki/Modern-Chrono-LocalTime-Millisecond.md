[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Millisecond**

# LocalTime.Millisecond

## Syntax

```freebasic
LocalTime.Millisecond
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as LocalTime t = LocalTime( 14, 30, 5, 123 )
print t.Millisecond          '' 123

'' The fractional part in whole milliseconds, 0 to 999 -- truncated, not
'' rounded, from the finer ticks below it
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
