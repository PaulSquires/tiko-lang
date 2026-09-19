[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **GetIterator**

# GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetIterator( ) as ArrayIterator( of T )
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 3 )

'' The RFC-0002 protocol -- IsValid / Value / MoveNext -- which is what
'' `for each` is built on
dim it as ArrayIterator( of long ) = v.GetIterator( )
while it.IsValid( )
    print it.Value( )
    it.MoveNext( )
wend

'' Value( ) returns BYREF, so an iterator can modify in place
dim jt as ArrayIterator( of long ) = v.GetIterator( )
jt.Value( ) = 99
print v[ 0 ]             '' 99
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the tiko-lang repository.
