[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Truncate**

# Truncate

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Truncate( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

'' TOWARDS ZERO, whichever side of it you are on
print Truncate( 2.7 )        '' 2
print Truncate( -2.7 )       '' -2

'' Floor and Ceil are the ones that pick a direction on the number line
'' rather than a direction relative to zero
print Floor( -2.7 )          '' -3
print Ceil( -2.7 )           '' -2
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
