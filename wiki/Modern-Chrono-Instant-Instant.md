[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Instant**

# Instant.Instant

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant( )
Instant( ticks )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' An INSTANT is a moment on the UTC timeline -- a tick count with no
'' calendar fields and no offset. A DateTime is the civil view of one.
dim as Instant i = Instant.FromUnixSeconds( 1767225600 )

print i.ToIsoString( )       '' 2026-01-01T00:00:00Z
print i.UnixSeconds          '' 1767225600

'' Use Instant to STORE and COMPARE a moment; use DateTime to show it
'' to somebody
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
