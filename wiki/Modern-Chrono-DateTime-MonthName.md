[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.MonthName**

# DateTime.MonthName

Returns a month's name in the user's language, or its abbreviation.

## Syntax

```freebasic
DateTime.MonthName( mo [, abbrev] )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print DateTime.MonthName( 8 )           '' August, on an English system
print DateTime.MonthName( 8, true )     '' Aug -- abbreviated

'' The OS locale's name, in the user's language: the output varies by
'' machine, so it is for display, not for a file that is read back.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
