[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Value**

# Value

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Value( ) byref as T
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim r as Result( of long, string ) = Ok( of long, string )( 42 )

print r.Value( )             '' 42

'' Value( ) returns BYREF, so it assigns in place
r.Value( ) = 43
print r.Value( )             '' 43

'' On a FAILED Result this raises FB_RTERROR_ILLEGALFUNCTIONCALL --
'' catchable by `on error`, and a bug at the call site otherwise.
'' Guard with IsOk( ), or use ValueOr( ).
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the tiko-lang repository.
