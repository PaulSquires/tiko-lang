[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.MonthUName**

# DateTime.MonthUName

Returns a month's name in the user's language, or its abbreviation, as a ustring.

## Syntax

```freebasic
DateTime.MonthUName
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' The same name as MonthName, in the user's language, as a USTRING
dim as ustring s = DateTime.MonthUName( 8 )

print s                      '' August, on an English system
print DateTime.MonthUName( 8, true )    '' Aug
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
