[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RoundMode**

# RoundMode

Rounded to a number of decimal places, with the rule stated explicitly.

## Syntax

```freebasic
RoundMode( byval digits as int32, byval mode as int32 ) as Currency
```

## Notes

- `Round( digits )` uses half-away-from-zero; this is the form that lets the rule be named instead of assumed.
- Half-to-even is what accounting standards generally ask for, because a long run of halves rounded away from zero drifts upwards.
- `digits` is 0 to 4 -- four is where the representation ends.
- Immutable.

## Examples

```freebasic
#import "std/money"
using money

dim as Currency c = CurrencyFromParts( 0, 2500 )      '' 0.2500

print c.Round( 3 ).ToString( )                '' 0.2500 -- unchanged, 3 dp
print c.RoundMode( 3, 0 ).ToString( )         '' 0.2500

'' The point is that the rule is written down at the call site rather
'' than inherited from whatever the default happens to be
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
