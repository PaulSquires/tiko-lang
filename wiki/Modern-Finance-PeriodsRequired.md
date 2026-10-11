[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PeriodsRequired**

# PeriodsRequired

## Syntax

```freebasic
PeriodsRequired( annuityTerms )
```

## Examples

```freebasic
#import "std/money"
using money

'' How many periods a payment needs to clear a balance.
''
'' IT RETURNS A double, DELIBERATELY.  The answer is almost never a whole
'' number, and 14.2 periods means the last payment is smaller -- not that
'' there are 14.  Rounding inside would hide which way it went.
dim as Decimal i = DecimalParse( "0.05" ).Value( )

dim as AnnuityTerms t = AnnuityTermsMake( i, 0, DecimalParse( "-100" ).Value( ), _
                                          DecimalParse( "1000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print PeriodsRequired( t ).Value( )      '' 14.20669908289047

'' A payment that does not cover the interest never amortizes, and that
'' gets a named code rather than an infinity.
dim as AnnuityTerms never_ = AnnuityTermsMake( i, 0, DecimalParse( "-10" ).Value( ), _
                                               DecimalParse( "1000" ).Value( ), _
                                               DecimalZero( ), PAY_END_OF_PERIOD )
print never_.Periods_                    '' 0
print never_.PresentValue_.ToString( )   '' 1000
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
