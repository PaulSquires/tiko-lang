[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinanceErrorCode**

# FinanceErrorCode

Lists the failure codes, such as FIN_INVALID_RATE and FIN_NO_SIGN_CHANGE.

## Syntax

```freebasic
FIN_OK  FIN_INVALID_RATE  FIN_NO_SIGN_CHANGE  FIN_NO_CONVERGENCE  ...
```

## Examples

```freebasic
#import "std/money"
using money

'' Thirteen codes, each one a thing a caller can act on differently.
'' The pair worth knowing: NO_SIGN_CHANGE means no root can EXIST, so a
'' better guess cannot help -- unlike NO_CONVERGENCE, which means the
'' range was right and the tolerance was not reached.
dim as Decimal allPositive( 0 to 2 ) = { DecimalFromInt( 100 ), _
                                         DecimalFromInt( 200 ), _
                                         DecimalFromInt( 300 ) }

var r = InternalRateOfReturn( allPositive( ) )

'' An ENUM comparison yields an integer, so assign it to a boolean to
'' print it as one -- only Decimal's own operator = returns boolean.
dim as boolean noRoot = ( r.Failure( ).Code( ) = FIN_NO_SIGN_CHANGE )
dim as boolean gaveUp = ( r.Failure( ).Code( ) = FIN_NO_CONVERGENCE )
print noRoot                             '' true
print gaveUp                             '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finerror.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
