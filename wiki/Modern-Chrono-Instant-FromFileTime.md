[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromFileTime**

# Instant.FromFileTime

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.FromFileTime( longint )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' A Windows FILETIME: 100 ns ticks since 1601-01-01 UTC
dim as DateTime d = DateTime.FromFileTime( 133689600000000000ll )

print d.Year                 '' 2024
print DateTime.FromFileTime( 0 ).ToIsoString( )     '' 1601-01-01T00:00:00Z

'' The same 100 ns tick this library uses, with a different epoch -- so
'' the conversion is an offset, not a rescale
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
