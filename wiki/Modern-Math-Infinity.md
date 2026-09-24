[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Infinity**

# Infinity

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Infinity( )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as double inf = Infinity( )

print IsInfinite( inf )      '' true
print inf > 1e308            '' -1 (true)

'' Arithmetic on it stays infinite, and the indeterminate forms are NaN
print IsInfinite( inf + 1 )  '' true
print IsNaN( inf - inf )     '' true
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
