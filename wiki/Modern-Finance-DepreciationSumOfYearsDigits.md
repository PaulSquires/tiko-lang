[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationSumOfYearsDigits**

# DepreciationSumOfYearsDigits

Returns one period's expense, weighted by how many periods of the life are left.

## Syntax

```freebasic
DepreciationSumOfYearsDigits( terms, period )
```

## Examples

```freebasic
#import "std/money"
using money

'' Weighted by position in the life: with a life of 7 the digits sum to
'' 28, so period one takes 7/28 of the base and period seven takes 1/28.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

print DepreciationSumOfYearsDigits( t, 1 ).Value( ).ToStringFixed( 2 )   '' 11250.00
print DepreciationSumOfYearsDigits( t, 7 ).Value( ).ToStringFixed( 2 )   '' 1607.14

'' Strictly decreasing, which is the character of the method.
dim as boolean falling = ( DepreciationSumOfYearsDigits( t, 1 ).Value( ) > _
                           DepreciationSumOfYearsDigits( t, 2 ).Value( ) )
print falling                            '' true

'' Over an odd life the middle period equals the straight-line amount --
'' a property of the method rather than a coincidence.
print ( DepreciationSumOfYearsDigits( t, 4 ).Value( ) = _
        DepreciationStraightLine( t, 4 ).Value( ) )      '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/findeprec.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
