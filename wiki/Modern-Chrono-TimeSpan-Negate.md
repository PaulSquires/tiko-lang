[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Negate**

# TimeSpan.Negate

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.Negate
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan t = TimeSpan( 1, 30, 0 )

print t.Negate( ).IsNegative             '' true
print t.Negate( ).ToIsoString( )         '' -PT1H30M
print t.Negate( ).Negate( ).ToIsoString( )        '' PT1H30M

'' The range is SYMMETRIC on purpose: MinValue is LLONG_MIN + 1, which
'' leaves LLONG_MIN itself as the Invalid sentinel and means negating
'' the smallest span cannot overflow
print TimeSpan.MinValue( ).Negate( ).IsValid      '' true
print ( TimeSpan.MinValue( ).Negate( ).Ticks = TimeSpan.MaxValue( ).Ticks )   '' true
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
