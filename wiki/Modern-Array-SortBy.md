[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **SortBy**

# SortBy

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

introsort, ascending, by a comparer

## Syntax

```freebasic
SortBy( a, less )
```

## Notes

- introsort, ascending, by a comparer

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of long )
v.Push( 5 ) : v.Push( 1 ) : v.Push( 4 )

'' A caller-supplied strict '<'. Reverse it for descending order:
SortBy( v, function( byref x as long, byref y as long ) as boolean
    return x > y
end function )

for i as long = 0 to v.Count - 1
    print v[ i ];
next
print                    '' 5 4 1

'' The comparison may capture, because it is taken as a generic rather
'' than as a procedure pointer -- a capturing lambda is a closure object
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Sorting  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
