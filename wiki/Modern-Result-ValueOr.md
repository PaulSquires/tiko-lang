[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **ValueOr**

# ValueOr

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
ValueOr( byref dflt as T ) byref as T
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim good as Result( of long, string ) = Ok( of long, string )( 42 )
dim bad  as Result( of long, string ) = Fail( of long, string )( "nope" )

dim as long fallback = -1

print good.ValueOr( fallback )     '' 42
print bad.ValueOr( fallback )      '' -1

'' The branch-free alternative to Value( ): never raises, whichever side
'' the Result is on
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the tiko-lang repository.
