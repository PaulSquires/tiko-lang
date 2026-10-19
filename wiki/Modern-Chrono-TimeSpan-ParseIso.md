[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.ParseIso**

# TimeSpan.ParseIso

Reads an ISO 8601 duration such as P1DT2H into a TimeSpan, or Invalid on failure.

## Syntax

```freebasic
TimeSpan.ParseIso( s )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as TimeSpan t = TimeSpan.ParseIso( "P1DT2H3M4S" )

print t.Days & " " & t.Hours & " " & t.Minutes & " " & t.Seconds    '' 1 2 3 4
print TimeSpan.ParseIso( "PT1.5S" ).TotalSeconds       '' 1.5
print TimeSpan.ParseIso( "-PT2H" ).IsNegative          '' true

'' A bad string yields Invalid -- no exception, no ERR( )
print TimeSpan.ParseIso( "1 hour" ).IsValid            '' false

'' There is no month or year designator: P1M would be a calendar period,
'' which a TimeSpan cannot represent
print TimeSpan.ParseIso( "P1M" ).IsValid               '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
