[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **FromUnixMicroseconds**

# FromUnixMicroseconds

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

An Instant from a count of microseconds since the Unix epoch.

## Syntax

```freebasic
Instant.FromUnixMicroseconds( byval v as longint ) as Instant
```

## Notes

- The finest of the three Unix-epoch constructors. Below this, use `FromTicks`, whose unit is 100 ns.
- Negative values are before 1970 and are perfectly valid.
- Out of range gives Invalid rather than wrapping.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as Instant i = Instant.FromUnixMicroseconds( 1500000 )

print i.UnixMicroseconds     '' 1500000
print i.UnixMilliseconds     '' 1500
print i.ToIsoString( )       '' 1970-01-01T00:00:01.5000000Z
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
