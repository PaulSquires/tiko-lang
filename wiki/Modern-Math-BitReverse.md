[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **BitReverse**

# BitReverse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Reverses the order of the bits.

## Syntax

```freebasic
BitReverse( byval x as T ) as T
```

## Notes

- Every bit of the type, not just the significant ones -- so the answer depends on the width and reversing a `ulong` 1 gives the top bit set.
- Used by FFTs, by some CRC formulations and by Gray-code addressing.
- **Not** `ByteSwap`: that reorders bytes and leaves each byte's bits alone.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as ulong x = 1
print hex( BitReverse( x ) ) '' 80000000 -- the bit moved to the top

'' Its own inverse, like ByteSwap
print BitReverse( BitReverse( x ) ) = x       '' -1 (true)

'' And NOT the same operation
print hex( ByteSwap( x ) )   '' 1000000
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
