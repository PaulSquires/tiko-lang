[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **BitWidth**

# BitWidth

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

How many bits are needed to represent the value.

## Syntax

```freebasic
BitWidth( byval x as T ) as long
```

## Notes

- One more than the index of the highest set bit, so it is the width of the value rather than of the type.
- Zero needs **0** bits, which is the convention that makes `BitWidth` and `NextPow2` agree.
- It is the type's width minus `LeadingZeros`.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as ulong x = 8
print BitWidth( x )          '' 4 -- 1000 needs four bits

dim as ulong y = 7
print BitWidth( y )          '' 3 -- 111 needs three

dim as ulong zero_ = 0
print BitWidth( zero_ )      '' 0 -- zero needs none
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
