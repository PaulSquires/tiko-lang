[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.Invalid**

# LocalTime.Invalid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalTime.Invalid
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime bad = LocalTime.Invalid( )

print bad.IsValid            '' false

'' BEWARE: comparing an Invalid value with ANYTHING is false, including
'' with itself -- deliberately, for the same reason IEEE NaN works that
'' way. IsValid is the only correct test.
dim as LocalTime other = LocalTime.Invalid( )
print ( bad = other )        '' false -- two Invalids are not equal
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
