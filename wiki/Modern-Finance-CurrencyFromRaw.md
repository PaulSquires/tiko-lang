[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyFromRaw**

# CurrencyFromRaw

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
CurrencyFromRaw( scaled )
```

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

'' The scaled integer directly: 1 unit is 10000
dim as longint raw = 123400
print CurrencyFromRaw( raw ).ToString( )  '' 12.3400

'' The inverse of Raw( ), for storing an amount in a database column or
'' a binary record as one integer
print CurrencyFromRaw( raw ).Raw( )       '' 123400
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
