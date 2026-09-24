[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **Some**

# Some

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Optional](Category-Optional), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Some( v ) as Optional( of T )
```

## Examples

```freebasic
#include once "fb/optional.bi"
using FB

dim o as Optional( of integer ) = Some( 42 )

print o.HasValue( )          '' true
print o.Value( )             '' 42

'' T is inferred FROM THE ARGUMENT, so `of T` need not be written --
'' unlike None( ), which has no argument to infer from.
'' Mind what the literal infers AS: 42 is an INTEGER, so
'' `dim o as Optional( of long ) = Some( 42 )` is error 24. Declare the
'' matching type, or pass a variable of the type you want.
```

---

**Library:** [Optional](Category-Optional) ✨  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members  
**Source:** `docs/optional/optional.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
