[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **GetIterator**

# GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetIterator( ) as MapIterator( of K, V )
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )
ages.Put( "ada", 36 )

'' Iteration yields a KeyValuePair, read through .key and .value
for each kv in ages
    print kv.key & " " & kv.value        '' ada 36
next

'' The protocol underneath, if a `for each` will not do
dim it as MapIterator( of string, integer ) = ages.GetIterator( )
while it.IsValid( )
    print it.Value( ).key
    it.MoveNext( )
wend
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the tiko-lang repository.
