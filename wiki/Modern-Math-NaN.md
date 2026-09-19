[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NaN**

# NaN

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NaN( )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as double n = NaN( )

print IsNaN( n )             '' true

'' It POISONS everything downstream, which is what makes it a useful
'' sentinel and a dangerous one
print IsNaN( n + 1 )         '' true
print IsNaN( n * 0 )         '' true

'' NaNF is the single-precision one
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
