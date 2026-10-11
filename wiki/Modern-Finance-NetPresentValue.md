[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **NetPresentValue**

# NetPresentValue

## Syntax

```freebasic
NetPresentValue( flows( ), ratePerPeriod )
```

## Examples

```freebasic
#import "std/money"
using money

'' EXACT, and flows(0) IS AT t = 0 -- undiscounted.
''
'' EXCEL'S NPV IS DIFFERENT: it discounts its first argument by one
'' period, so the correct spreadsheet spelling of a project with an
'' up-front outlay is 'f0 + NPV( rate, rest )'.  Forgetting that is the
'' commonest error in capital budgeting.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print NetPresentValue( f( ), DecimalParse( "0.10" ).Value( ) ).Value( ).ToStringFixed( 6 )   '' 115.565877

'' At a zero rate it is simply the sum.
print NetPresentValue( f( ), DecimalZero( ) ).Value( ).ToString( )   '' 400
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincash.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
