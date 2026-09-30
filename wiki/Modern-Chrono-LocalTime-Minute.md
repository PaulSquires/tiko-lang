[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Minute**

# LocalTime.Minute

## Syntax

```freebasic
LocalTime.Minute
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )
print t.Minute               '' 30
print LocalTime.Midnight( ).Minute      '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
