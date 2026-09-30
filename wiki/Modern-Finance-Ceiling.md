[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Ceiling**

# Ceiling

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

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
