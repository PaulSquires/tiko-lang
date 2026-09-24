[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ToString**

# ToString

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

shortest string that reads back EXACTLY

## Syntax

```freebasic
ToString( v )
ToString( v, fmt )
ToString( longint )
```

## Notes

- shortest string that reads back EXACTLY
- controlled

## Examples

```freebasic
#include once "fb/mathtext.bi"
using FB

'' THE SHORTEST STRING THAT READS BACK EXACTLY -- round-trip precision,
'' which STR( ) does not promise
print ToString( 0.1 + 0.2 )  '' 0.30000000000000004
print ToString( 1.0 )        '' 1
print ToString( 1.0 / 3.0 )  '' 0.3333333333333333

'' So ToString followed by TryParseDouble returns the identical double,
'' for every finite value
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
