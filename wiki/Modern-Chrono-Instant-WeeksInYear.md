[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.WeeksInYear**

# Instant.WeeksInYear

## Syntax

```freebasic
Instant.WeeksInYear( y )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' 52 or 53, depending on which weekdays the year starts and ends on
print DateTime.WeeksInYear( 2026 )      '' 53
print DateTime.WeeksInYear( 2025 )      '' 52

'' A static: it is a property of the YEAR, not of a particular moment
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
