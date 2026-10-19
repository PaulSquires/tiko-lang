[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DayCountFractionDouble**

# DayCountFractionDouble

Returns the fraction of a year between two dates on a basis, as a double.

## Syntax

```freebasic
DayCountFractionDouble( d1, d2, basis )
```

## Examples

```freebasic
#import "std/chrono"
#import "std/money"
using money, chrono

'' The same fraction as a double, for the dated discounting in
'' fincash.tiko where the exponent cannot be exact anyway.
dim as LocalDate a = LocalDate( 2026, 1, 1 )
dim as LocalDate b = LocalDate( 2026, 7, 1 )

print DayCountFractionDouble( a, b, DAYCOUNT_ACTUAL_365_FIXED )   '' 0.4958904...
print DayCountFractionDouble( a, b, DAYCOUNT_THIRTY_360_US )      '' 0.5
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
