[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Add**

# TimeSpan.Add

## Syntax

```freebasic
TimeSpan.Add
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan a = TimeSpan( 1, 0, 0 )
dim as TimeSpan b = TimeSpan( 0, 30, 0 )

print a.Add( b ).ToIsoString( )          '' PT1H30M

'' IMMUTABLE -- a new value comes back and the receiver is untouched
a.Add( b )
print a.ToIsoString( )                    '' PT1H, unchanged

'' Overflow yields Invalid; it never wraps
print TimeSpan.MaxValue( ).Add( a ).IsValid       '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
