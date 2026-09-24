[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Result**

# Result

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

"nothing is here, AND this is why"

## Syntax

```freebasic
Result( of T, E )
Result( of string, string )
```

## Notes

- "nothing is here, AND this is why"

## Examples

```freebasic
#include once "fb/result.bi"
using FB

'' A value, or the reason there isn't one. The difference from Optional
'' is the E: Optional says "nothing is here", Result says "nothing is
'' here, AND this is why".
dim r as Result( of long, string )

'' A DEFAULT-CONSTRUCTED RESULT IS A FAILURE. That is deliberate: a
'' Result nobody has set must not read as success, or every forgotten
'' assignment becomes a silent Ok.
print r.IsOk( )              '' false

r = Ok( of long, string )( 42 )
print r.IsOk( )              '' true
print r.Value( )             '' 42
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Result Or Optional?  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
