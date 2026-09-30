[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyFromInt**

# CurrencyFromInt

## Syntax

```freebasic
CurrencyFromInt( n )
```

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

'' Whole units, exactly -- no rounding step at all
dim as longint n = 42
print CurrencyFromInt( n ).ToString( )    '' 42.0000

'' The one to use for a literal amount, since it cannot pick up a
'' binary-fraction error on the way in
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
