[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **None**

# None

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Optional](Category-Optional), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
None( of T )
```

## Examples

```freebasic
#include once "fb/optional.bi"
using FB

dim o as Optional( of integer ) = None( of integer )( )

print o.HasValue( )          '' false

'' The type argument must be written: there is no parameter to infer
'' from. A default-constructed Optional is already empty, so this is for
'' saying "absent" out loud, typically in a return.
dim d as Optional( of integer )
print d.HasValue( )          '' false
```

---

**Library:** [Optional](Category-Optional) ✨  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members  
**Source:** `docs/optional/optional.txt` in the tiko-lang repository.
