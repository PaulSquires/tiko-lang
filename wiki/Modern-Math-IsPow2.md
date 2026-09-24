[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsPow2**

# IsPow2

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Whether the value is a power of two.

## Syntax

```freebasic
IsPow2( byval x as T ) as boolean
```

## Notes

- **Zero is not**, which is the case a hand-written `( x and ( x - 1 ) ) = 0` gets wrong.
- One is: 2^0.
- The test behind an alignment check and a hash-table capacity assertion.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as ulong a = 8
print IsPow2( a )            '' true

dim as ulong b = 6
print IsPow2( b )            '' false

'' ZERO IS NOT a power of two -- which the usual one-liner gets wrong
dim as ulong zero_ = 0
print IsPow2( zero_ )        '' false
print ( ( zero_ and ( zero_ - 1 ) ) = 0 )     '' -1 -- the wrong answer
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
