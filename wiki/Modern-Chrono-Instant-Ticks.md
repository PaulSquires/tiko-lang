[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Ticks**

# Instant.Ticks

## Syntax

```freebasic
Instant.Ticks
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Ticks since 0001-01-01 in the value's OWN offset -- civil ticks, not
'' UTC ones. AssumeUtc( ).Ticks or ToInstant( ).Ticks give the moment.
print d.Ticks > 0            '' -1 (true)

print DateTime.FromTicks( d.Ticks, d.OffsetMinutes ).ToIsoString( )
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
