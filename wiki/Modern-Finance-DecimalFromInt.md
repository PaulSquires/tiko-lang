[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromInt**

# DecimalFromInt

## Syntax

```freebasic
DecimalFromInt( n )
```

## Examples

```freebasic
#import "std/money"
using money

'' A LONGINT, exactly -- every one of them fits
print DecimalFromInt( 0 ).ToString( )     '' 0
print DecimalFromInt( -1234567890123456789 ).ToString( )
'' -1234567890123456789

'' including MIN_VALUE_LONGINT, which has no positive counterpart in a
'' LONGINT and is exactly where a hand-written negation wraps
print DecimalFromInt( -9223372036854775808 ).ToString( )
'' -9223372036854775808
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
