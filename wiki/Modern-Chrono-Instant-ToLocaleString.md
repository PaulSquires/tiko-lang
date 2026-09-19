[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **ToLocaleString**

# ToLocaleString

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The date and time as the machine's locale writes them.

## Syntax

```freebasic
ToLocaleString( byval style as long = lsShort ) as string
```

## Notes

- **Whatever the machine's locale says**, so the exact text cannot be asserted and must never be written to a file. `ToIsoString` is the one that round-trips.
- `lsShort` and `lsLong` are the two styles; which is which is the OS's decision, not this library's.
- `ToLocaleDateString` and `ToLocaleTimeString` are the halves.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 0 )

'' Locale dependent, so assert shape rather than content
print len( d.ToLocaleString( ) ) > 0          '' -1 (true)
print len( d.ToLocaleString( lsLong ) ) > 0   '' -1 (true)

'' The one that does NOT vary
print d.ToIsoString( )       '' 2026-08-13T14:30:05
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
