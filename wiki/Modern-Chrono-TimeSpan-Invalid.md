[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **TimeSpan.Invalid**

# TimeSpan.Invalid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TimeSpan.Invalid
```

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as TimeSpan bad = TimeSpan.Invalid( )

print bad.IsValid            '' false

'' ABSORBING: anything touching an Invalid becomes Invalid
print bad.Add( TimeSpan.FromDays( 1 ) ).IsValid         '' false
print bad.Duration( ).IsValid                            '' false

'' And it never compares equal to anything, itself included
print ( bad = TimeSpan.Invalid( ) )      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
