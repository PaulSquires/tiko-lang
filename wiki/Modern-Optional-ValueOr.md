[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **ValueOr**

# ValueOr

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Optional](Category-Optional), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
ValueOr( byref dflt as T ) byref as T
```

## Examples

```freebasic
#include once "fb/optional.bi"
using FB

dim some_ as Optional( of integer ) = Some( 42 )
dim none_ as Optional( of integer ) = None( of integer )( )

dim as integer fallback = -1

print some_.ValueOr( fallback )    '' 42
print none_.ValueOr( fallback )    '' -1

'' Never raises, so no HasValue( ) guard is needed
```

---

**Library:** [Optional](Category-Optional) ✨  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members  
**Source:** `docs/optional/optional.txt` in the tiko-lang repository.
