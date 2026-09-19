[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **GCD**

# GCD

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GCD( a, b )
```

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as long a = 12, b = 18
print GCD( a, b )            '' 6

'' GCD with zero is the other operand, which is the identity that makes
'' a fold over a list work with no special first case
dim as long z = 0
print GCD( a, z )            '' 12
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
