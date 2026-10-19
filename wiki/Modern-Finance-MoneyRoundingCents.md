[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MoneyRoundingCents**

# MoneyRoundingCents

Returns the default policy: two places, half-to-even, every posted amount rounded.

## Syntax

```freebasic
MoneyRoundingCents( )
```

## Examples

```freebasic
#import "std/money"
using money

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
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
