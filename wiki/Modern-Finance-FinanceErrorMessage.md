[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinanceErrorMessage**

# FinanceErrorMessage

## Syntax

```freebasic
FinanceErrorMessage( code )
```

## Examples

```freebasic
#import "std/money"
using money

'' Fixed English for a code, with no allocation and no locale.  A program
'' showing this to a person localizes from the code instead.
print FinanceErrorMessage( FIN_OK )                '' ok
print FinanceErrorMessage( FIN_NO_SIGN_CHANGE )    '' no sign change, so no root exists
print FinanceErrorMessage( FIN_EMPTY_SERIES )      '' empty series
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finerror.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
