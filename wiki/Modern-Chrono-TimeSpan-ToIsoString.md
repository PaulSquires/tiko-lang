[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.ToIsoString**

# TimeSpan.ToIsoString

Returns the duration as ISO 8601 text, such as PT1H30M.

## Syntax

```freebasic
TimeSpan.ToIsoString
```

## Examples

```freebasic
#import "std/chrono"
using chrono

print TimeSpan( 1, 2, 3, 4, 5 ).ToIsoString( )     '' P1DT2H3M4.005S
print TimeSpan( 2, 0, 0 ).ToIsoString( )           '' PT2H
print TimeSpan.Zero( ).ToIsoString( )              '' PT0S

'' ISO 8601 duration form, so it round-trips through ParseIso. A
'' negative span carries the sign in front of the P.
print TimeSpan.FromHours( -2 ).ToIsoString( )      '' -PT2H
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
