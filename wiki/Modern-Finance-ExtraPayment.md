[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ExtraPayment**

# ExtraPayment

Holds extra principal paid over a range of periods; overlapping ranges add up.

## Syntax

```freebasic
x.FromPeriod_  x.ToPeriod_  x.Amount_
```

## Examples

```freebasic
#import "std/money"
using money

'' Extra principal applied over a range of periods.  Overlapping ranges
'' ADD, so a recurring extra plus a one-off both land in the same period.
dim as ExtraPayment monthly = ExtraPaymentRecurring( 1, 60, DecimalParse( "100" ).Value( ) )
dim as ExtraPayment bonus = ExtraPaymentOnce( 36, DecimalParse( "5000" ).Value( ) )

print monthly.FromPeriod_                '' 1
print monthly.ToPeriod_                  '' 60
print bonus.FromPeriod_                  '' 36
print bonus.ToPeriod_                    '' 36 -- a one-off is a range of one
print bonus.Amount_.ToString( )          '' 5000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
