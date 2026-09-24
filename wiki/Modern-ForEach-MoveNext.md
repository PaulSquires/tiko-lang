[Home](Home) › [For Each](Category-For-Each) › [For Each](Category-For-Each) › **MoveNext**

# MoveNext

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [For Each](Category-For-Each), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MoveNext( )
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Push( 1 ) : v.Push( 2 )

dim it as ArrayIterator( of long ) = v.GetIterator( )
print it.Value( )            '' 1
it.MoveNext( )               '' advance -- it returns nothing
print it.Value( )            '' 2
it.MoveNext( )
print it.IsValid( )          '' false

'' The order is always IsValid -> Value -> MoveNext. An iterator that
'' advanced inside Value( ) could not be read twice.
```

---

**Library:** [For Each](Category-For-Each) ✨  
**Category:** [For Each](Category-For-Each)  
**Documented under:** What Can Be Walked  
**Source:** `docs/for_each/for-each.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
