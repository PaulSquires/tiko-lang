[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **InternalRateOfReturn**

# InternalRateOfReturn

## Syntax

```freebasic
InternalRateOfReturn( flows( ) )
InternalRateOfReturn( flows( ), solverOptions )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The rate at which the net present value is zero.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

var irr = InternalRateOfReturn( f( ) )
print irr.Value( ).ToStringFixed( 12 )   '' 0.153221378772

'' Its definition, checked by substitution -- the NPV at the IRR is zero.
print NetPresentValue( f( ), irr.Value( ) ).Value( ).ToStringFixed( 8 )   '' 0.00000000

'' NO SIGN CHANGE MEANS NO ROOT CAN EXIST, and that is a different
'' answer from "did not converge": a better guess cannot help.
dim as Decimal allPos( 0 to 2 ) = { DecimalFromInt( 100 ), DecimalFromInt( 200 ), _
                                    DecimalFromInt( 300 ) }
print InternalRateOfReturn( allPos( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
