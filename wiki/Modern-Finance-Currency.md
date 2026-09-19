[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Currency**

# Currency

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Currency(1)
Currency(2)
```

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

'' A FIXED-POINT decimal: four decimal places in a longint, so money
'' arithmetic is exact where a double is not
dim as Currency c = CurrencyFromDouble( 0.1 )
dim as Currency d = CurrencyFromDouble( 0.2 )

print ( c + d ).ToString( )  '' 0.3000 -- exact

'' The double sum PRINTS as 0.3, which is why the error is so easy to
'' miss, but it is not 0.3 and the comparison says so
print 0.1 + 0.2              '' 0.3
print ( 0.1 + 0.2 = 0.3 )    '' 0 -- false

print c.Raw( )               '' 1000 -- the underlying scaled integer
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
