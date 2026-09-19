[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegInfinity**

# NegInfinity

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
NegInfinity( )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as double ninf = NegInfinity( )

print IsInfinite( ninf )     '' true
print IsNegative( ninf )     '' true
print ninf < -1e308          '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
