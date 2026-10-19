[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.MonthName**

# DateTime.MonthName

Returns the English name of a month number, or its three-letter abbreviation.

## Syntax

```freebasic
DateTime.MonthName( mo [, abbrev] )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print DateTime.MonthName( 8 )           '' August
print DateTime.MonthName( 8, true )     '' Aug -- abbreviated

'' INVARIANT ENGLISH, never the OS locale, so it is safe to write to a
'' file and read back. ToLocaleDateString is the locale-aware one.
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
