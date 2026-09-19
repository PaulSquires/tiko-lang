[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Optional**

# Optional

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

"nothing is here"

## Syntax

```freebasic
Optional( of T )
```

## Notes

- "nothing is here"

## Examples

```freebasic
#include once "fb/result.bi"
using FB

'' Optional is Result's smaller sibling: absence with no explanation.
'' Use Optional when the miss needs no reason -- a lookup that found
'' nothing -- and Result when it does.
#include once "fb/optional.bi"

dim o as Optional( of integer ) = Some( 42 )
print o.HasValue( )          '' true
print o.Value( )             '' 42

dim r as Result( of long, string ) = Fail( of long, string )( "not a number" )
print r.IsOk( )              '' false
print r.Failure( )           '' not a number -- the part Optional cannot carry
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Result Or Optional?  
**Source:** `docs/result/result.txt` in the tiko-lang repository.
