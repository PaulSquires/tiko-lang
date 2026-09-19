[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalOne**

# DecimalOne

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalOne( )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' One at scale 0 -- the multiplicative identity, spelled out so that a
'' loop accumulating a product has something to start from
dim as Decimal acc = DecimalOne( )
for i as long = 1 to 3
    acc = acc * DecimalFromInt( i )
next
print acc.ToString( )        '' 6

print DecimalOne( ).ToString( )       '' 1
print DecimalOne( ).Sign( )           '' 1
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
