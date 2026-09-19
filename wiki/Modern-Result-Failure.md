[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Failure**

# Failure

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Failure( ) byref as E
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim r as Result( of long, string ) = Fail( of long, string )( "not a number" )

print r.Failure( )           '' not a number

'' Byref, like Value( )
r.Failure( ) = "bad input"
print r.Failure( )           '' bad input

'' On a SUCCESSFUL Result this raises, symmetrically with Value( ) on a
'' failure. IsOk( ) is the guard for both.
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the tiko-lang repository.
