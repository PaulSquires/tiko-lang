[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Pairs**

# Pairs

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

for 'for each (k, v)'

## Syntax

```freebasic
Pairs( ) as MapPairView( of K, V )
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )
ages.Put( "ada", 36 )

'' Pairs( ) yields a TUPLE instead of a KeyValuePair, so the loop can
'' destructure into two named variables
for each (who, age) in ages.Pairs( )
    print who & " is " & age             '' ada is 36
next

'' The default `for each kv in ages` form names its halves kv.key and
'' kv.value and costs one copy fewer
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
