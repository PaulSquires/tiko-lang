[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **ForEach**

# ForEach

Applies a procedure to every element, in order, passing each byref.

## Syntax

```freebasic
ForEach( byref a as Array( of T ), byref f as F )
```

## Notes

- Each element is passed **byref**, so the function can modify it in place.
- It takes the callable as a **generic**, not a procedure pointer, which is what lets a **capturing lambda** work -- a closure object is not a procptr.
- A plain `@proc` or a non-capturing lambda works too, because calling through a generic parameter is just `f( x )` either way.
- `for each` is the alternative when the body is written inline rather than passed.

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
for i as long = 1 to 3
    v.Push( i )
next

'' A CAPTURING lambda, which a procedure-pointer parameter could not take
dim as longint total = 0
ForEach( v, sub[ byref total ]( byref x as long )
    total += x
end sub )
print total                  '' 6

'' Byref, so it can modify in place
ForEach( v, sub( byref x as long ) : x *= 10 : end sub )
print v[ 0 ]                 '' 10
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
