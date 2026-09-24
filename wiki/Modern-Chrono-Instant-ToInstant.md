[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToInstant**

# Instant.ToInstant

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.ToInstant
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 ).WithOffset( 60 )

'' The moment this civil reading names, using its OWN offset
dim as Instant i = d.ToInstant( )
print i.ToIsoString( )       '' 2026-08-13T13:30:05.1230000Z -- an hour earlier

'' Without an offset there is no moment to compute, so it is Invalid --
'' AssumeUtc is the explicit way through
dim as DateTime u = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print u.ToInstant( ).IsValid     '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
