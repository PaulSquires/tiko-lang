[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **IsSortedBy**

# IsSortedBy

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsSortedBy( a, less ) as boolean
```

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of string )
v.Push( "fig" ) : v.Push( "pear" ) : v.Push( "banana" )

'' Ordered by length, which is not the same question as alphabetically
print IsSortedBy( v, function( byref x as string, byref y as string ) as boolean
    return len( x ) < len( y )
end function )               '' true

print IsSorted( v )          '' false -- not in alphabetical order

'' Use the same comparison here that was used to sort, or the answer is
'' about a different ordering than the one that was applied
```

---

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the tiko-lang repository.
