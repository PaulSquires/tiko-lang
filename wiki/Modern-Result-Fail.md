[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Fail**

# Fail

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Result](Category-Result), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Fail( of T, E )
Fail( of long, string )
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim r as Result( of long, string ) = Fail( of long, string )( "not a number" )

print r.IsOk( )              '' false
print r.Failure( )           '' not a number

'' T and E MAY BE THE SAME TYPE -- Result( of string, string ) is a normal
'' thing to want. The slots stay distinct because they are two fields,
'' not a union.
```

---

**Library:** [Result](Category-Result) ✨  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the tiko-lang repository.
