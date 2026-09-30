[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DayCountFractionDouble**

# DayCountFractionDouble

## Syntax

```freebasic
DayCountFractionDouble( d1, d2, basis )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The same fraction as a double, for the dated discounting in
'' fb/fincash.bi where the exponent cannot be exact anyway.
dim as LocalDate a = LocalDate( 2026, 1, 1 )
dim as LocalDate b = LocalDate( 2026, 7, 1 )

print DayCountFractionDouble( a, b, DAYCOUNT_ACTUAL_365_FIXED )   '' 0.4958904...
print DayCountFractionDouble( a, b, DAYCOUNT_THIRTY_360_US )      '' 0.5
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
