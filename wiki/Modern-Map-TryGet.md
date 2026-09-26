[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **TryGet**

# TryGet

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryGet( k, byref out as V ) as boolean
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

dim as integer got
if ages.TryGet( "ada", got ) then print got        '' 36

'' A miss leaves the output alone and does NOT insert -- unlike m[ k ]
got = -1
print ages.TryGet( "alan", got )    '' false
print got                            '' -1, untouched
print ages.Count                     '' 1 -- still just "ada"
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
