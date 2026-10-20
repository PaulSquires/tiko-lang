[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.WeekdayName**

# DateTime.WeekdayName

Returns a weekday's name in the user's language, 1 being Monday, or its abbreviation.

## Syntax

```freebasic
DateTime.WeekdayName( dow [, abbrev] )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Takes the ISO day number: Monday 1 through Sunday 7
print DateTime.WeekdayName( 4 )         '' Thursday, on an English system
print DateTime.WeekdayName( 4, true )   '' Thu

'' In the user's language, like MonthName
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
