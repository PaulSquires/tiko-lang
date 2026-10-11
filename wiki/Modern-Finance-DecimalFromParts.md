[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromParts**

# DecimalFromParts

## Syntax

```freebasic
DecimalFromParts( lo, mid, hi, neg, scale )
```

## Examples

```freebasic
#import "std/money"
using money

'' The .NET constructor, limb for limb: three 32-bit words of mantissa, a
'' sign flag and a scale.  Use it when the parts came from somewhere else
'' -- a COM DECIMAL, a file, a database driver
print DecimalFromParts( 1, 0, 0, false, 0 ).ToString( )  '' 1
print DecimalFromParts( 0, 1, 0, false, 0 ).ToString( )  '' 4294967296
print DecimalFromParts( 0, 0, 1, false, 0 ).ToString( )  '' 18446744073709551616
print DecimalFromParts( 1, 0, 0, true, 4 ).ToString( )   '' -0.0001

'' and the limbs read back out unchanged
dim as Decimal d = DecimalFromParts( 1, 0, 0, true, 4 )
print d.Lo( ); " "; d.Mid( ); " "; d.Hi( ); " "; d.Scale( ); " "; d.IsNegative( )
'' 1 0 0 4 true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
