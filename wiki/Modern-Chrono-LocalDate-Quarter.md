[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.Quarter**

# LocalDate.Quarter

## Syntax

```freebasic
LocalDate.Quarter
```

## Examples

```freebasic
#import "std/chrono"
using FB

print LocalDate( 2026, 1, 1 ).Quarter       '' 1
print LocalDate( 2026, 8, 13 ).Quarter      '' 3
print LocalDate( 2026, 12, 31 ).Quarter     '' 4

'' Calendar quarters, 1 to 4. A fiscal year that does not start in
'' January is a business rule, not a calendar one.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
