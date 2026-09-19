[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalCompare**

# DecimalCompare

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalCompare( a, b )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' -1, 0 or +1, blind to the scale: 1.10 and 1.1 are the same number
print DecimalCompare( DecimalParse( "1.10" ).Value( ), _
                      DecimalParse( "1.1" ).Value( ) )    '' 0
print DecimalCompare( DecimalParse( "1" ).Value( ), _
                      DecimalParse( "2" ).Value( ) )      '' -1

'' -2 means one of them was Invalid.  It is deliberately NOT -1, so a
'' caller that forgets to check cannot mistake it for 'less than'
print DecimalCompare( DecimalInvalid( ), DecimalOne( ) )   '' -2
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
