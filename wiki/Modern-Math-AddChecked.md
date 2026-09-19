[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **AddChecked**

# AddChecked

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A + b, or **nothing** if the result would overflow.

## Syntax

```freebasic
AddChecked( byval a as T, byval b as T ) as Optional( of T )
```

## Notes

- Returns an **Optional**: empty means the true result does not fit in `T`. The overflow is reported rather than wrapped, which is what `a + b` does silently.
- The check happens **before** the operation, so nothing undefined occurs on the way to finding out.
- `AddSaturating` clamps instead, and `AddWrapping` wraps on purpose.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as byte a = 100, b = 100

var r = AddChecked( a, b )
print r.HasValue( )          '' false -- 200 does not fit in a BYTE

dim as byte small = 1
var ok = AddChecked( small, small )
print ok.HasValue( )         '' true
print ok.Value( )
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
