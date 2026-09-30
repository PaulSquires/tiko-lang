[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Currency**

# Currency

## Syntax

```freebasic
Currency(1)
Currency(2)
```

## Examples

```freebasic
#import "std/money"
using FB

'' A FIXED-POINT decimal: four decimal places in a longint, so money
'' arithmetic is exact where a double is not
dim as Currency c = CurrencyFromDouble( 0.1 )
dim as Currency d = CurrencyFromDouble( 0.2 )

print ( c + d ).ToString( )  '' 0.3000 -- exact

'' The double sum PRINTS as 0.3, which is why the error is so easy to
'' miss, but it is not 0.3 and the comparison says so
print 0.1 + 0.2              '' 0.3
print ( 0.1 + 0.2 = 0.3 )    '' 0 -- false

print c.Raw( )               '' 1000 -- the underlying scaled integer
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
