[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TryParse**

# Instant.TryParse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.TryParse
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d

'' The lenient parse: ISO, and the common near-ISO shapes
print DateTime.TryParse( "2026-08-13T14:30:05", d )  '' true
print DateTime.TryParse( "2026-08-13 14:30:05", d )  '' true -- a space
print DateTime.TryParse( "2026-08-13", d )           '' true -- date only

print DateTime.TryParse( "not a date", d )           '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
