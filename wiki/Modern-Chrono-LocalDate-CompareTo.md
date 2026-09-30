[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.CompareTo**

# LocalDate.CompareTo

## Syntax

```freebasic
LocalDate.CompareTo
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalDate a = LocalDate( 2026, 1, 1 )
dim as LocalDate b = LocalDate( 2026, 8, 13 )

print a.CompareTo( b )       '' -1
print b.CompareTo( a )       '' 1
print a.CompareTo( a )       '' 0

'' -2 when either side is Invalid -- NOT an ordering, so an invalid
'' date cannot silently sort to one end
print a.CompareTo( LocalDate.Invalid( ) )      '' -2
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
