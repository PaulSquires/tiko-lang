[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ProfitabilityIndex**

# ProfitabilityIndex

## Syntax

```freebasic
ProfitabilityIndex( flows( ), ratePerPeriod )
```

## Examples

```freebasic
#import "std/money"
using money

'' The present value of everything after t = 0, over the initial outlay.
'' Above one exactly when the NPV is positive.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print ProfitabilityIndex( f( ), DecimalParse( "0.10" ).Value( ) ).Value( ).ToStringFixed( 8 )   '' 1.11556588

'' The two measures agree by construction, and still do at a discount
'' rate above the internal rate of return.
dim as Decimal high = DecimalParse( "0.30" ).Value( )
print ( ProfitabilityIndex( f( ), high ).Value( ) < DecimalOne( ) )     '' true
print ( NetPresentValue( f( ), high ).Value( ) < DecimalZero( ) )       '' true

'' A zero initial outlay is a named refusal, not an infinity.
dim as Decimal z( 0 to 2 ) = { DecimalZero( ), DecimalFromInt( 100 ), _
                               DecimalParse( "-50" ).Value( ) }
print ProfitabilityIndex( z( ), DecimalParse( "0.10" ).Value( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincash.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
