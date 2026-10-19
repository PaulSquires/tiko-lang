[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ParseIso**

# Instant.ParseIso

Reads ISO 8601 text into a date-time, or Invalid if it is not ISO 8601.

## Syntax

```freebasic
Instant.ParseIso(+ USTRING overloads, .ToIsoUString)
Instant.ParseIso
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime.ParseIso( "2026-08-13T14:30:05.123" )
print d.Hour & " " & d.Minute            '' 14 30

'' An offset in the text is kept, not normalised away
print DateTime.ParseIso( "2026-08-13T14:30:05+01:00" ).OffsetMinutes     '' 60

print DateTime.ParseIso( "13/08/2026" ).IsValid      '' false -- ISO only
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
