[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Subtract**

# TimeSpan.Subtract

## Syntax

```freebasic
TimeSpan.Subtract
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan a = TimeSpan( 1, 0, 0 )
dim as TimeSpan b = TimeSpan( 0, 30, 0 )

print a.Subtract( b ).ToIsoString( )     '' PT30M

'' A negative result is normal, not an error -- that is why the type is
'' signed
print b.Subtract( a ).ToIsoString( )     '' -PT30M
print b.Subtract( a ).IsNegative         '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
