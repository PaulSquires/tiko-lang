[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TryParseExact**

# Instant.TryParseExact

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.TryParseExact( s, pattern, result )
Instant.TryParseExact
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d

if DateTime.TryParseExact( "13/08/2026", "dd/MM/yyyy", d ) then print d.Day

'' FALSE rather than an Invalid value, when a mismatch is expected and
'' is not a bug
print DateTime.TryParseExact( "nonsense", "dd/MM/yyyy", d )      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
