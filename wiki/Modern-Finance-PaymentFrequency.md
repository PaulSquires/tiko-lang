[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PaymentFrequency**

# PaymentFrequency

## Syntax

```freebasic
PAY_MONTHLY  PAY_BIWEEKLY  PAY_ACCELERATED_BIWEEKLY  ...
```

## Examples

```freebasic
#import "std/money"
using FB

'' How often a PAYMENT is made -- a separate question from how often
'' interest compounds, which is what lets one code path serve both the
'' US and Canadian mortgage conventions.
print PAY_MONTHLY                        '' 12
print PAY_WEEKLY                         '' 52

'' THE ACCELERATED FORMS ARE NEGATIVE ON PURPOSE.  They are not a rate
'' conversion: an accelerated-biweekly payment is the MONTHLY payment
'' divided by two, posted 26 times a year, which retires the loan early.
'' A negative value forces every SELECT CASE to handle them.
dim as boolean isAccelerated = ( PAY_ACCELERATED_BIWEEKLY < 0 )
print isAccelerated                      '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
