[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Apportion**

# Apportion

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Apportion( total, weights( ), result( ) )
```

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

'' Splits a total so the parts sum EXACTLY to it -- the rounding
'' remainder is distributed rather than dropped, which is what makes
'' three-way splits of a penny add up
dim as Currency total_ = CurrencyFromDouble( 10.0 )
dim as longint weights( 0 to 2 ) = { 1, 1, 1 }
dim parts( 0 to 2 ) as Currency

Apportion( total_, weights( ), parts( ) )

dim as Currency sum_ = CurrencyFromInt( 0 )
for i as long = 0 to 2
    print parts( i ).ToString( )
    sum_ = sum_ + parts( i )
next
print sum_.ToString( )       '' 10.0000 -- exactly the input
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
