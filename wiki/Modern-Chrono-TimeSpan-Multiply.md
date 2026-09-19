[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Multiply**

# TimeSpan.Multiply

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.Multiply( f )
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan( 0, 30, 0 )

print t.Multiply( 2 ).ToIsoString( )     '' PT1H
print t.Multiply( 0.5 ).ToIsoString( )   '' PT15M
print t.Multiply( -1 ).IsNegative        '' true

'' The factor is a double, so scaling by a fraction is exact to the tick
'' and rounds half away from zero below it
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
