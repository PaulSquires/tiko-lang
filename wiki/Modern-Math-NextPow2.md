[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextPow2**

# NextPow2

The smallest power of two at or above the value.

## Syntax

```freebasic
NextPow2( byval x as T ) as T
```

## Notes

- **At or above**: a value that is already a power of two comes back unchanged, which is what a capacity computation wants.
- Zero gives 1.
- A value with no power of two above it in the type saturates rather than wrapping to zero.

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as ulong a = 5
print NextPow2( a )          '' 8

'' Already a power of two, so it does not move
dim as ulong b = 8
print NextPow2( b )          '' 8

dim as ulong zero_ = 0
print NextPow2( zero_ )      '' 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
