[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **IsValid**

# IsValid

Whether this Currency holds a real amount.

## Syntax

```freebasic
IsValid( ) as boolean
```

## Notes

- **The only correct test.** An Invalid value never compares equal to anything, itself included -- the same rule the chrono types follow, and for the same reason: an equality that succeeded would let bad values through validation.
- Worth checking after a parse and after any arithmetic that could overflow.
- A default-constructed Currency is zero, and valid.

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

dim as Currency c = CurrencyFromInt( 10 )
print c.IsValid( )           '' true

dim as Currency zero_
print zero_.IsValid( )       '' true -- default-constructed is 0, not Invalid

print CurrencyInvalid( ).IsValid( )           '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
