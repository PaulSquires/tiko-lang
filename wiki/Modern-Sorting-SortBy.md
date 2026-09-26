[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **SortBy**

# SortBy

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n log n) worst   in place, unstable

## Syntax

```freebasic
SortBy( a, less )
```

## Notes

- O(n log n) worst — in place, unstable

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of ustring )
v.Push( "pear" ) : v.Push( "fig" ) : v.Push( "banana" )

'' A caller-supplied strict '<' -- by length here, not alphabetically
SortBy( v, function( byref x as ustring, byref y as ustring ) as boolean
    return len( x ) < len( y )
end function )

for i as long = 0 to v.Count - 1
    print v[ i ]
next                         '' fig / pear / banana

'' Taken as a generic rather than a procedure pointer, so a CAPTURING
'' lambda works too -- a closure object is not a procptr
```

---

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
