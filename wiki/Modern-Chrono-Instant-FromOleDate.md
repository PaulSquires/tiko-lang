[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromOleDate**

# Instant.FromOleDate

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.FromOleDate( double )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The OLE automation date, the same serial Excel and ADO use
dim as DateTime d = DateTime.FromOleDate( 46247.0 )

print d.ToIsoString( )       '' 2026-08-13T00:00:00
print DateTime.FromOleDate( 0 ).ToIsoString( )      '' 1899-12-30T00:00:00
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
