[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyFromInt**

# CurrencyFromInt

Returns a Currency of a whole number of units, exactly.

## Syntax

```freebasic
CurrencyFromInt( n )
```

## Examples

```freebasic
#import "std/money"
using money

'' Whole units, exactly -- no rounding step at all
dim as int64 n = 42
print CurrencyFromInt( n ).ToString( )    '' 42.0000

'' The one to use for a literal amount, since it cannot pick up a
'' binary-fraction error on the way in
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
