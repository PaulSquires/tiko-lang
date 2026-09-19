[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **ArrayIterator**

# ArrayIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator `for each` uses over an `Array( of T )`.

## Syntax

```freebasic
ArrayIterator( of T )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- `Value( )` returns **byref**, so `for each byref v in a` can modify elements in place.
- It holds a **pointer** to the array, not a copy -- an iterator is created per loop and must not deep-copy the container.
- It is invalidated by anything that reallocates the storage, which a `Push` past the capacity does.

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 3 )

dim it as ArrayIterator( of long ) = v.GetIterator( )
while it.IsValid( )
    print it.Value( )        '' 1 / 2 / 3
    it.MoveNext( )
wend

'' Value( ) is byref, so it assigns through
dim jt as ArrayIterator( of long ) = v.GetIterator( )
jt.Value( ) = 99
print v[ 0 ]                 '' 99
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the tiko-lang repository.
