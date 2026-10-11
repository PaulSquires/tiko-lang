[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnualizeReturn**

# AnnualizeReturn

## Syntax

```freebasic
AnnualizeReturn( periodReturn, frequency )
```

## Examples

```freebasic
#import "std/money"
using money

'' GEOMETRIC: ( 1 + r )^f - 1, NOT r * f.  Both are one-liners and the
'' wrong one appears in a great deal of published code, which is why this
'' is a named function rather than left inline.
print AnnualizeReturn( 0.01, RETURN_MONTHLY )            '' 0.1268250301319697
print AnnualizeReturn( 0.0, RETURN_MONTHLY )             '' 0

'' Annual frequency is the identity.
print AnnualizeReturn( 0.07, RETURN_ANNUAL )             '' 0.07000000000000001

'' It is always MORE than the naive product, because gains compound.
dim as boolean compounds = ( AnnualizeReturn( 0.01, RETURN_MONTHLY ) > 0.12 )
print compounds                          '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
