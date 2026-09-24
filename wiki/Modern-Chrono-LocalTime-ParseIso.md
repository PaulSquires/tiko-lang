[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.ParseIso**

# LocalTime.ParseIso

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
LocalTime.ParseIso(+ USTRING overloads, .ToIsoUString)
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as LocalTime t = LocalTime.ParseIso( "14:30:05" )
print t.Hour & " " & t.Minute            '' 14 30

print LocalTime.ParseIso( "14:30:05.123" ).Millisecond      '' 123

'' A bad string yields Invalid -- there is no exception and no ERR( ).
'' Use TryParseIso when the difference matters at the call site.
print LocalTime.ParseIso( "not a time" ).IsValid            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
