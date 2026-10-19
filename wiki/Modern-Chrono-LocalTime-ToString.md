[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.ToString**

# LocalTime.ToString

Returns the time of day as ISO 8601 text, the same as ToIsoString.

## Syntax

```freebasic
LocalTime.ToString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime( 14, 30, 5, 0 )

print t.ToString( )          '' 14:30:05

'' The same text as ToIsoString for this type. An Invalid value prints
'' as an empty string rather than as a misleading time.
print LocalTime.Invalid( ).ToString( ) = ""   '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
