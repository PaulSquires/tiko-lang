[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.Month**

# LocalDate.Month

## Syntax

```freebasic
LocalDate.Month
```

## Examples

```freebasic
#import "std/chrono"
using FB

print LocalDate( 2026, 8, 13 ).Month      '' 8

'' 1 to 12, ONE-BASED -- January is 1, not 0
print LocalDate( 2026, 1, 1 ).Month       '' 1
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
