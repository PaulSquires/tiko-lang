[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **SortListBy**

# SortListBy

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n log n) worst   O(1) extra, STABLE

## Syntax

```freebasic
SortListBy( l, less )
```

## Notes

- O(n log n) worst — O(1) extra, STABLE

## Examples

```freebasic
#include once "fb/linkedlist.bi"
#include once "fb/sort.bi"
using FB

dim q as LinkedList( of ustring )
q.PushBack( "pear" ) : q.PushBack( "fig" ) : q.PushBack( "banana" )

SortListBy( q, function( byref x as ustring, byref y as ustring ) as boolean
    return len( x ) < len( y )
end function )

for each v in q
    print v
next                         '' fig / pear / banana

'' The 'prv' pointers are rewritten as the chain is relinked, which is
'' the only difference from the singly-linked version of this algorithm
```

---

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
