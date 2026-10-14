[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalMinusOne**

# DecimalMinusOne

## Syntax

```freebasic
DecimalMinusOne( )
```

## Examples

```freebasic
#import "std/money"
using money

'' Minus one at scale 0.  Multiplying by it negates without the unary
'' operator, and it is what Sign( ) is reporting against
print DecimalMinusOne( ).ToString( )       '' -1
print DecimalMinusOne( ).Sign( )           '' -1
print DecimalMinusOne( ).IsNegative( )     '' true

print ( DecimalParse( "1.25" ).Value( ) * DecimalMinusOne( ) ).ToString( )
'' -1.25
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
