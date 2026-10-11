[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyFromRaw**

# CurrencyFromRaw

## Syntax

```freebasic
CurrencyFromRaw( scaled )
```

## Examples

```freebasic
#import "std/money"
using money

'' The scaled integer directly: 1 unit is 10000
dim as int64 raw = 123400
print CurrencyFromRaw( raw ).ToString( )  '' 12.3400

'' The inverse of Raw( ), for storing an amount in a database column or
'' a binary record as one integer
print CurrencyFromRaw( raw ).Raw( )       '' 123400
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
