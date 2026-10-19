[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.ToString**

# LocalDate.ToString

Returns the date as ISO 8601 text, the same as ToIsoString.

## Syntax

```freebasic
LocalDate.ToString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print LocalDate( 2026, 8, 13 ).ToString( )         '' 2026-08-13

'' Same text as ToIsoString for this type. Invalid prints as an empty
'' string rather than as a plausible-looking date.
print LocalDate.Invalid( ).ToString( ) = ""         '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
