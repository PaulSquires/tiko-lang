[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalApportion**

# DecimalApportion

## Syntax

```freebasic
DecimalApportion( total, scale, weights( ), result( ) )
```

## Examples

```freebasic
#import "std/money"
using money

'' Splitting 100.00 three ways gives 33.33 each, whose sum is 99.99.
'' Every accounting system has to decide where the missing cent goes, and
'' doing it ad hoc is how a reconciliation fails.  Largest-remainder: THE
'' PARTS ALWAYS SUM TO THE TOTAL, EXACTLY
dim as int64 w( 0 to 2 ) = { 1, 1, 1 }
redim as Decimal r( 0 )

DecimalApportion( DecimalParse( "100.00" ).Value( ), 2, w( ), r( ) )

print r( 0 ).ToString( )   '' 33.34
print r( 1 ).ToString( )   '' 33.33
print r( 2 ).ToString( )   '' 33.33
print ( r( 0 ) + r( 1 ) + r( 2 ) ).ToString( )   '' 100.00

'' Weights need not be equal, and the scale is yours to pick -- which is
'' the one thing currency.tiko's Apportion could not offer, having only
'' four decimal places to apportion at
dim as int64 w2( 0 to 2 ) = { 1, 2, 3 }
DecimalApportion( DecimalParse( "100.00" ).Value( ), 2, w2( ), r( ) )
print r( 0 ).ToString( ); " "; r( 1 ).ToString( ); " "; r( 2 ).ToString( )
'' 16.67 33.33 50.00
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
