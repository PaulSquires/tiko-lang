[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.IsNegative**

# TimeSpan.IsNegative

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.IsNegative
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.FromHours( -2 ).IsNegative      '' true
print TimeSpan.FromHours( 2 ).IsNegative       '' false
print TimeSpan.Zero( ).IsNegative              '' false -- zero is not negative

'' A negative span is normal: it is what `earlier - later` gives, and
'' the reason the type is signed at all
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
