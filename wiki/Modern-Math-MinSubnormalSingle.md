[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinSubnormalSingle**

# MinSubnormalSingle

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MinSubnormalSingle( )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as single m = MinSubnormalSingle( )

print m > 0                  '' -1 (true)
print IsSubnormal( m )       '' true

'' The single-precision counterpart of MinSubnormalDouble
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
