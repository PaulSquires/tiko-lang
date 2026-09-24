[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinanceErrorMessage**

# FinanceErrorMessage

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
FinanceErrorMessage( code )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Fixed English for a code, with no allocation and no locale.  A program
'' showing this to a person localizes from the code instead.
print FinanceErrorMessage( FIN_OK )                '' ok
print FinanceErrorMessage( FIN_NO_SIGN_CHANGE )    '' no sign change, so no root exists
print FinanceErrorMessage( FIN_EMPTY_SERIES )      '' empty series
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finerror.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
