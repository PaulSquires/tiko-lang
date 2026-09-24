[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ReturnFrequency**

# ReturnFrequency

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
RETURN_ANNUAL  RETURN_QUARTERLY  RETURN_MONTHLY  RETURN_WEEKLY  RETURN_DAILY_252  RETURN_DAILY_365
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' How many observations make a year.  BOTH DAILY FORMS ARE OFFERED
'' because the choice is a convention, not a fact: 252 is trading days,
'' 365 is calendar days, and a Sharpe ratio computed one way is not
'' comparable with one computed the other.
print RETURN_MONTHLY                     '' 12
print RETURN_DAILY_252                   '' 252

'' Annualizing is GEOMETRIC, so 1% a month is 12.68% a year, not 12%.
print AnnualizeReturn( 0.01, RETURN_MONTHLY )            '' 0.1268250301319697
print AnnualizeReturn( 0.01, RETURN_ANNUAL )             '' 0.01
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
