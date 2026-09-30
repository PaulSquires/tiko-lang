[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AddScaled**

# AddScaled

Adds `c * num / den` to an accumulator, exactly.

## Syntax

```freebasic
CurrencyAccum.AddScaled( byref c as Currency, byval num as longint, byval den as longint )
```

## Notes

- A **rational** factor rather than a double one, so a third of an amount is exact instead of being 0.3333333333333333 of it.
- The multiplication happens in 128 bits before the division, so neither the product nor the quotient loses a unit.
- The shape for splitting an amount by shares, or applying a rate that is naturally a fraction.

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

dim acc as CurrencyAccum
dim as Currency total_ = CurrencyFromInt( 100 )

'' Exactly one third, three times -- not 0.3333... three times
for i as long = 1 to 3
    acc.AddScaled( total_, 1, 3 )
next

print acc.Total( ).ToString( )                '' 100.0000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
