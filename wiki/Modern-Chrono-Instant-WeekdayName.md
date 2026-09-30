[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.WeekdayName**

# Instant.WeekdayName

## Syntax

```freebasic
Instant.WeekdayName( dow [, abbrev] )
```

## Examples

```freebasic
#import "std/chrono"
using FB

'' Takes the ISO day number: Monday 1 through Sunday 7
print DateTime.WeekdayName( 4 )         '' Thursday
print DateTime.WeekdayName( 4, true )   '' Thu

'' Invariant English, like MonthName
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
