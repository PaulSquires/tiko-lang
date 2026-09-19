[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsFinite**

# IsFinite

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsFinite( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsFinite( 1.0 )         '' true
print IsFinite( Infinity( ) ) '' false
print IsFinite( NaN( ) )      '' false

'' Neither infinite NOR NaN -- the check to make before trusting a value
'' to be arithmetic
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
