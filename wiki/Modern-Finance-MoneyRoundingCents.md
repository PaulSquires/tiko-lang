[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingCents**

# MoneyRoundingCents

## Syntax

```freebasic
MoneyRoundingCents( )
```

## Examples

```freebasic
#import "std/money"
using FB

'' Two places, half-to-even, rounding every posted amount.  The default
'' in every record that carries a policy.
dim as MoneyRounding p = MoneyRoundingCents( )

'' HALF-TO-EVEN, which is why the two ties below go opposite ways: it
'' stops a long ledger drifting upward the way half-up would.
print MoneyRound( DecimalParse( "2.675" ).Value( ), p ).ToString( )   '' 2.68
print MoneyRound( DecimalParse( "2.665" ).Value( ), p ).ToString( )   '' 2.66
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
