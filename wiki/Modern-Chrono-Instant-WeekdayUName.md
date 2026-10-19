[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.WeekdayUName**

# DateTime.WeekdayUName

Returns the English name of a weekday, 1 being Monday, as a ustring.

## Syntax

```freebasic
DateTime.WeekdayUName
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as ustring s = DateTime.WeekdayUName( 4 )

print s                      '' Thursday
print DateTime.WeekdayUName( 7, true )  '' Sun
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
