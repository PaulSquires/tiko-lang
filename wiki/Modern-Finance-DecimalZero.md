[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalZero**

# DecimalZero

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalZero( )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' Zero at scale 0.  A default-constructed Decimal is the same thing --
'' zero is the meaningful default for a number, so there is no
'' uninitialised state to guard against
dim as Decimal fresh
print DecimalZero( ).ToString( )    '' 0
print DecimalZero( ).IsZero( )      '' true
print DecimalZero( ).IsValid( )     '' true
print fresh.IsZero( )               '' true

'' A zero mantissa never carries a sign, so there is no negative zero to
'' have to compare against
print ( -DecimalZero( ) ).IsNegative( )   '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
