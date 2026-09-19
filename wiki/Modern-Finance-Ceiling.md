[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Ceiling**

# Ceiling

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Rounded up to a whole unit.

## Syntax

```freebasic
Ceiling( ) as Currency
```

## Notes

- **Towards positive infinity**, so -12.34 becomes -12, not -13. `Truncate` is the towards-zero one.
- `Floor` is the other direction and `Round( digits )` the one that takes a precision.
- Immutable.

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

dim as Currency c = CurrencyFromDouble( 12.34 )
print c.Ceiling( ).ToString( )                '' 13.0000

'' Towards POSITIVE infinity, which is not the same as away from zero
dim as Currency n = CurrencyFromDouble( -12.34 )
print n.Ceiling( ).ToString( )                '' -12.0000
print n.Floor( ).ToString( )                  '' -13.0000
print n.Truncate( ).ToString( )               '' -12.0000
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
