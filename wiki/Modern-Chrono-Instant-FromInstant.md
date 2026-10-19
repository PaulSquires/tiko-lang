[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **DateTime.FromInstant**

# DateTime.FromInstant

Returns the date-time a moment shows on a clock with the given UTC offset.

## Syntax

```freebasic
DateTime.FromInstant( instant, offMin )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant i = Instant.FromUnixSeconds( 1767225600 )

'' The offset is REQUIRED: an Instant is a moment, and turning it into
'' civil fields needs to know whose clock to read it on
print DateTime.FromInstant( i, 0 ).ToIsoString( )       '' 2026-01-01T00:00:00Z
print DateTime.FromInstant( i, 60 ).ToIsoString( )      '' 2026-01-01T01:00:00+01:00

'' Both are the SAME MOMENT, shown on two clocks
print DateTime.FromInstant( i, 60 ).ToInstant( ).UnixSeconds     '' 1767225600
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
