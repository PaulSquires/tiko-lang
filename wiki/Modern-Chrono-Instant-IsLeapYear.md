[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsLeapYear**

# Instant.IsLeapYear

## Syntax

```freebasic
Instant.IsLeapYear( y )
```

## Examples

```freebasic
#import "std/chrono"
using FB

print DateTime.IsLeapYear( 2024 )       '' true
print DateTime.IsLeapYear( 2025 )       '' false

'' The full Gregorian rule, not just "divisible by 4"
print DateTime.IsLeapYear( 1900 )       '' false -- century, not by 400
print DateTime.IsLeapYear( 2000 )       '' true  -- divisible by 400
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
