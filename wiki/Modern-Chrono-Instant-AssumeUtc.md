[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.AssumeUtc**

# Instant.AssumeUtc

## Syntax

```freebasic
Instant.AssumeUtc
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' Reads an UNZONED value AS IF it were UTC, giving the moment it then
'' names. The name is a warning: it is an assumption, not a conversion.
dim as Instant i = d.AssumeUtc( )

print i.ToIsoString( )       '' 2026-08-13T14:30:05.1230000Z

'' ToInstant is the one to use when the value already carries an offset
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
