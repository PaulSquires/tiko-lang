[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromInt**

# DecimalFromInt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalFromInt( n )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' A LONGINT, exactly -- every one of them fits
print DecimalFromInt( 0 ).ToString( )     '' 0
print DecimalFromInt( -1234567890123456789 ).ToString( )
'' -1234567890123456789

'' including MIN_VALUE_LONGINT, which has no positive counterpart in a
'' LONGINT and is exactly where a hand-written negation wraps
print DecimalFromInt( -9223372036854775808 ).ToString( )
'' -9223372036854775808
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
