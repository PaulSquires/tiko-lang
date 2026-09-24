[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromInstant**

# Instant.FromInstant

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.FromInstant( instant, offMin )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as Instant i = Instant.FromUnixSeconds( 1767225600 )

'' The offset is REQUIRED: an Instant is a moment, and turning it into
'' civil fields needs to know whose clock to read it on
print DateTime.FromInstant( i, 0 ).ToIsoString( )       '' 2026-01-01T00:00:00Z
print DateTime.FromInstant( i, 60 ).ToIsoString( )      '' 2026-01-01T01:00:00+01:00

'' Both are the SAME MOMENT, shown on two clocks
print DateTime.FromInstant( i, 60 ).ToInstant( ).UnixSeconds     '' 1767225600
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
