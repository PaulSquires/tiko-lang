[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ParseExact**

# Instant.ParseExact

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Instant.ParseExact( s, pattern )
Instant.ParseExact
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

'' Parse against a PATTERN, for text whose layout you already know
dim as DateTime d = DateTime.ParseExact( "13/08/2026", "dd/MM/yyyy" )

print d.Year & "-" & d.Month & "-" & d.Day       '' 2026-8-13

'' The text must match the pattern exactly -- that is the point of it
print DateTime.ParseExact( "2026-08-13", "dd/MM/yyyy" ).IsValid      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
