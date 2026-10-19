[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromJulianDay**

# Instant.FromJulianDay

Creates a date-time from a fractional Julian day.

## Syntax

```freebasic
Instant.FromJulianDay( float64 )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Julian day: FRACTIONAL and NOON-BASED, which is where the half-day
'' comes from. JD 2451545.0 is 2000-01-01T12:00 UTC.
dim as DateTime d = DateTime.FromJulianDay( 2451545.0 )

print d.ToIsoString( )       '' 2000-01-01T12:00:00 -- no Z: the result
                             '' carries no offset, it is a civil reading
print d.Hour                 '' 12 -- noon, not midnight
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
