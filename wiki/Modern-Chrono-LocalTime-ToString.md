[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.ToString**

# LocalTime.ToString

## Syntax

```freebasic
LocalTime.ToString
```

## Examples

```freebasic
#import "std/chrono"
using FB

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )

print t.ToString( )          '' 14:30:05

'' The same text as ToIsoString for this type. An Invalid value prints
'' as "Invalid" rather than as a misleading time.
print LocalTime.Invalid( ).ToString( )
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
