[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyInvalid**

# CurrencyInvalid

The Invalid Currency value.

## Syntax

```freebasic
CurrencyInvalid( ) as Currency
```

## Notes

- Overflow and a failed parse both land here rather than raising, in the same style the chrono types use.
- **Absorbing**: arithmetic touching it yields Invalid, so one bad value in a long sum does not quietly become a plausible number.
- `IsValid` is the only correct test -- an Invalid does not compare equal to anything, itself included.

## Examples

```freebasic
#import "std/money"
using money

dim as Currency bad = CurrencyInvalid( )
print bad.IsValid( )         '' false

'' Absorbing: it survives arithmetic rather than being papered over
dim as Currency ten = CurrencyFromInt( 10 )
print ( bad + ten ).IsValid( )                '' false

'' And it never compares equal, so IsValid is the test
print ( bad = CurrencyInvalid( ) )            '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
