[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.ToIsoUString**

# TimeSpan.ToIsoUString

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.ToIsoUString
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' The same text as ToIsoString, as a USTRING -- for a call site that
'' is already working in ustring and would otherwise convert
dim as ustring s = TimeSpan( 2, 0, 0 ).ToIsoUString( )

print s                      '' PT2H
print len( s )               '' 4

'' TryParseIso and ParseIso are both overloaded on ustring too, so the
'' round trip stays in one string type
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
