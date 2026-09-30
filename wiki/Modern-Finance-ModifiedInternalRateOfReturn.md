[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ModifiedInternalRateOfReturn**

# ModifiedInternalRateOfReturn

## Syntax

```freebasic
ModifiedInternalRateOfReturn( flows( ), financeRate, reinvestRate )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The WELL-POSED alternative to IRR: it discounts the negative flows at
'' one rate and compounds the positive ones at another, so it has exactly
'' one solution by construction rather than one per sign change.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print ModifiedInternalRateOfReturn( f( ), DecimalParse( "0.10" ).Value( ), _
                                    DecimalParse( "0.12" ).Value( ) ).Value( ).ToStringFixed( 12 )

'' A higher reinvestment rate gives a higher modified return -- the
'' monotonicity that makes the measure mean something.
dim as Decimal lo = ModifiedInternalRateOfReturn( f( ), DecimalParse( "0.10" ).Value( ), _
                                                  DecimalParse( "0.05" ).Value( ) ).Value( )
dim as Decimal hi = ModifiedInternalRateOfReturn( f( ), DecimalParse( "0.10" ).Value( ), _
                                                  DecimalParse( "0.20" ).Value( ) ).Value( )
print ( hi > lo )                        '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
