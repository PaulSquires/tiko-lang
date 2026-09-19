[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.IsValid**

# Instant.IsValid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.IsValid
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print DateTime( 2026, 8, 13 ).IsValid     '' true
print DateTime( 2025, 2, 30 ).IsValid     '' false -- no such date
print DateTime( 2026, 8, 13, 25, 0, 0, 0 ).IsValid       '' false

'' Out-of-range construction yields Invalid rather than raising
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
