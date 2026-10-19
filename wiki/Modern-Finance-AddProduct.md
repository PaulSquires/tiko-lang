[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AddProduct**

# AddProduct

Adds an amount times a rate to a running total, rounding only once at the end.

## Syntax

```freebasic
CurrencyAccum.AddProduct( byref c as Currency, byval rate as float64 )
```

## Notes

- A `CurrencyAccum` holds a **128-bit** running total, so a long series of multiplied amounts does not lose a scaled unit per step.
- This is the shape for applying a tax or interest rate to many lines and totalling them: rounding once at the end is not the same number as rounding each line.
- `Total( )` reads the accumulated value back as a Currency.

## Examples

```freebasic
#import "std/money"
using money

dim acc as CurrencyAccum
dim as Currency line_ = CurrencyFromDouble( 19.99 )

'' Rate applied per line, but rounded only ONCE, at the end
for i as int32 = 1 to 3
    acc.AddProduct( line_, 0.075 )
next

print acc.Count( )           '' 3
print acc.Total( ).ToString( )                '' 4.4978
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members
