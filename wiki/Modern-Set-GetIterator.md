[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **GetIterator**

# GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetIterator( ) as SetIterator( of T )
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
for i as integer = 1 to 3
    seen.Add( i )
next

'' Value( ) is BYREF, and the RFC-0002 protocol is what `for each` uses
dim it as SetIterator( of integer ) = seen.GetIterator( )
dim as integer total
while it.IsValid( )
    total += it.Value( )
    it.MoveNext( )
wend
print total                  '' 6
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
