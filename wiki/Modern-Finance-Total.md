[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Total**

# Total

The accumulated total, as a Currency.

## Syntax

```freebasic
CurrencyAccum.Total( ) as Currency
```

## Notes

- Where the **single rounding** happens: the accumulator carries 128 bits and this is the one point at which the result comes back to four decimal places.
- Reading it does not reset the accumulator; `Reset` does that.
- `Count` says how many amounts went in, which is how a caller checks it accumulated what it meant to.

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

dim acc as CurrencyAccum

for i as long = 1 to 3
    acc.Add( CurrencyFromDouble( 0.1 ) )
next

print acc.Count( )           '' 3
print acc.Total( ).ToString( )                '' 0.3000

'' Reading does not reset
print acc.Total( ).ToString( )                '' 0.3000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
