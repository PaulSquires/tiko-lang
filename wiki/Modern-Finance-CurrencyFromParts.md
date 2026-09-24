[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyFromParts**

# CurrencyFromParts

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
CurrencyFromParts( w, tt )
```

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

'' Units and four-decimal fraction, given separately and exactly
dim as longint units_ = 12, cents = 3400
print CurrencyFromParts( units_, cents ).ToString( )        '' 12.3400

'' Which is how to write an amount down without going anywhere near a
'' double
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
