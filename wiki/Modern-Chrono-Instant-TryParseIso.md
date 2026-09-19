[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TryParseIso**

# Instant.TryParseIso

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.TryParseIso
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d

if DateTime.TryParseIso( "2026-08-13T14:30:05", d ) then print d.Year

'' FALSE on a bad string, and the output is CLOBBERED to Invalid rather
'' than left as it was
print DateTime.TryParseIso( "13/08/2026", d )        '' false
print d.IsValid                                      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
