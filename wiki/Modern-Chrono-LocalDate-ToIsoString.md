[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.ToIsoString**

# LocalDate.ToIsoString

Returns the date as text in the form 2026-08-13, or empty text if it is Invalid.

## Syntax

```freebasic
LocalDate.ToIsoString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalDate( 2026, 8, 13 ).ToIsoString( )      '' 2026-08-13

'' Always zero-padded to YYYY-MM-DD, so it sorts as text in the same
'' order it sorts as a date
print LocalDate( 1, 1, 1 ).ToIsoString( )          '' 0001-01-01
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
