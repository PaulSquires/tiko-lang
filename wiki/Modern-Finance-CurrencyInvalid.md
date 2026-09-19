[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **CurrencyInvalid**

# CurrencyInvalid

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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
#include once "fb/currency.bi"
using FB

dim as Currency bad = CurrencyInvalid( )
print bad.IsValid( )         '' false

'' Absorbing: it survives arithmetic rather than being papered over
dim as Currency ten = CurrencyFromInt( 10 )
print ( bad + ten ).IsValid( )                '' false

'' And it never compares equal, so IsValid is the test
print ( bad = CurrencyInvalid( ) )            '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
