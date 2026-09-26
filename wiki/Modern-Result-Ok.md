[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Ok**

# Ok

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Ok( of T, E )
Ok( of long, ustring )
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim r as Result( of long, ustring ) = Ok( of long, ustring )( 42 )

print r.IsOk( )              '' true
print r.Value( )             '' 42

'' Both type arguments are written out because only T appears in the
'' parameter list -- E cannot be inferred from anything
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
