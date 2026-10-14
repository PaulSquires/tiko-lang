[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Divide**

# TimeSpan.Divide

## Syntax

```freebasic
TimeSpan.Divide( f )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan( 1, 0, 0 )

print t.Divide( 2 ).ToIsoString( )       '' PT30M
print t.Divide( 4 ).ToIsoString( )       '' PT15M

'' Dividing by zero yields Invalid rather than raising or giving an
'' infinite span
print t.Divide( 0 ).IsValid              '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
