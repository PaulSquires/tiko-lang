[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromSerial**

# Instant.FromSerial

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.FromSerial( double )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The OLE/BASIC serial date: days since 1899-12-30, fractional
dim as DateTime d = DateTime.FromSerial( 46247.6042 )

print d.Year & "-" & d.Month           '' 2026-8
print DateTime.FromSerial( 0 ).ToIsoString( )      '' 1899-12-30T00:00:00

'' The pair to the Serial property, for talking to Excel, ADO and
'' anything else built on the same convention
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
