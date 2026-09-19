[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **HasValue**

# HasValue

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Optional](Category-Optional), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
HasValue( ) as boolean
```

## Examples

```freebasic
#include once "fb/optional.bi"
using FB

dim o as Optional( of integer ) = Some( 42 )
print o.HasValue( )          '' true

o.Clear( )
print o.HasValue( )          '' false

'' The guard before Value( ), which RAISES on an empty Optional.
'' This replaces the sentinel idiom, where -1 might be "absent" or might
'' be a legitimate index and nothing in the type says which.
```

---

**Library:** [Optional](Category-Optional) ✨  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members  
**Source:** `docs/optional/optional.txt` in the tiko-lang repository.
