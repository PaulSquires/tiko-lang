[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyFromDouble**

# CurrencyFromDouble

## Syntax

```freebasic
CurrencyFromDouble( d )
```

## Examples

```freebasic
#import "std/money"
using money

dim as Currency c = CurrencyFromDouble( 1.5 )
print c.ToString( )          '' 1.5000

'' It rounds to four decimals, and the half-way cases go the way the
'' DOUBLE actually lies rather than the way the literal reads: 0.00005
'' is a hair below one half-unit in binary, so it rounds DOWN
print CurrencyFromDouble( 0.00005 ).ToString( )   '' 0.0000
print CurrencyFromDouble( 0.00006 ).ToString( )   '' 0.0001
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
