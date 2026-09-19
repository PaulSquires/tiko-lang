[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.IsZero**

# TimeSpan.IsZero

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.IsZero
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

print TimeSpan.Zero( ).IsZero             '' true
print TimeSpan.FromTicks( 1 ).IsZero      '' false

'' Reads better than `= TimeSpan.Zero( )` and, unlike that comparison,
'' answers FALSE rather than misleading you when the span is Invalid
print TimeSpan.Invalid( ).IsZero          '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
