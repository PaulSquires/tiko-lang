[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromCurrency**

# DecimalFromCurrency

## Syntax

```freebasic
DecimalFromCurrency( c )
```

## Examples

```freebasic
#import "std/outcome"
#import "std/money"
using money, outcome


'' EXACT, always: Currency is four decimal places and Decimal has
'' twenty-eight, so nothing can be lost in this direction
dim as Currency c = CurrencyParse( "19.99" ).Value( )
print DecimalFromCurrency( c ).ToString( )   '' 19.9900
print DecimalFromCurrency( c ).Scale( )      '' 4

'' Going the other way is Decimal.ToCurrency( ), which rounds half-to-even
'' at the fourth place and is Invalid outside Currency's range
print DecimalParse( "0.12345" ).Value( ).ToCurrency( ).ToString( )
'' 0.1234 -- half-to-even on the tie
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
