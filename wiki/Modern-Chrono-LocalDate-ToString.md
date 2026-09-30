[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.ToString**

# LocalDate.ToString

## Syntax

```freebasic
LocalDate.ToString
```

## Examples

```freebasic
#import "std/chrono"
using FB

print LocalDate( 2026, 8, 13 ).ToString( )         '' 2026-08-13

'' Same text as ToIsoString for this type. Invalid prints as a word
'' rather than as a plausible-looking date.
print LocalDate.Invalid( ).ToString( )
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
