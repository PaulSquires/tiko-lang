[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.WeekdayName**

# DateTime.WeekdayName

Returns the English name of a weekday, 1 being Monday, or its abbreviation.

## Syntax

```freebasic
DateTime.WeekdayName( dow [, abbrev] )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Takes the ISO day number: Monday 1 through Sunday 7
print DateTime.WeekdayName( 4 )         '' Thursday
print DateTime.WeekdayName( 4, true )   '' Thu

'' Invariant English, like MonthName
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
