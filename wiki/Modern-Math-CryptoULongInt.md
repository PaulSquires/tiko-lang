[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CryptoULongInt**

# CryptoULongInt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
CryptoULongInt( )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

'' Eight cryptographically secure bytes as one number
dim as ulongint a = CryptoULongInt( )
dim as ulongint b = CryptoULongInt( )

print a <> b                 '' -1 (true), with overwhelming probability

'' This is what RngFromEntropy uses for its seed
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
