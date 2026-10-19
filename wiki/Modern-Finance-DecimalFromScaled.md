[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromScaled**

# DecimalFromScaled

Returns a whole number over a power of ten as a Decimal: 1999 at scale 2 is 19.99.

## Syntax

```freebasic
DecimalFromScaled( mantissa, scale )
```

## Examples

```freebasic
#import "std/money"
using money

'' value = mantissa / 10 ^ scale, exactly.  The usual way to write a
'' literal amount without going through text
print DecimalFromScaled( 1999, 2 ).ToString( )   '' 19.99
print DecimalFromScaled( -1999, 2 ).ToString( )  '' -19.99

'' the smallest value the type has
print DecimalFromScaled( 1, 28 ).ToString( )
'' 0.0000000000000000000000000001

'' the scale must be 0..28; anything else is Invalid rather than clamped
print DecimalFromScaled( 1, 29 ).IsValid( )      '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
