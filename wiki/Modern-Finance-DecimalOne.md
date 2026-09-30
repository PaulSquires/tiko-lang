[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalOne**

# DecimalOne

## Syntax

```freebasic
DecimalOne( )
```

## Examples

```freebasic
#import "std/money"
using FB

'' One at scale 0 -- the multiplicative identity, spelled out so that a
'' loop accumulating a product has something to start from
dim as Decimal acc = DecimalOne( )
for i as int32 = 1 to 3
    acc = acc * DecimalFromInt( i )
next
print acc.ToString( )        '' 6

print DecimalOne( ).ToString( )       '' 1
print DecimalOne( ).Sign( )           '' 1
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
