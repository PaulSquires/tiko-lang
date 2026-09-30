[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.AddMilliseconds**

# Instant.AddMilliseconds

## Syntax

```freebasic
Instant.AddMilliseconds(float64)
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.AddMilliseconds( 877 ).Second     '' 6
print d.AddMilliseconds( -123 ).Millisecond       '' 0
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
