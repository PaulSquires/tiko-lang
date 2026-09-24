[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromUInt**

# DecimalFromUInt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalFromUInt( u )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' A ULONGINT, exactly.  The whole 64-bit range fits inside the 96-bit
'' mantissa, so nothing is lost at the top end either
print DecimalFromUInt( 0ull ).ToString( )   '' 0
print DecimalFromUInt( 18446744073709551615ull ).ToString( )
'' 18446744073709551615
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
