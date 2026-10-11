[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromUnixSeconds**

# Instant.FromUnixSeconds

## Syntax

```freebasic
Instant.FromUnixSeconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant i = Instant.FromUnixSeconds( 0 )

print i.ToIsoString( )       '' 1970-01-01T00:00:00Z -- the Unix epoch
print Instant.FromUnixSeconds( 1767225600 ).ToIsoString( )   '' 2026-01-01T00:00:00Z

'' Negative values are before 1970 and are perfectly valid
print Instant.FromUnixSeconds( -1 ).ToIsoString( )           '' 1969-12-31T23:59:59Z
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
