[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MaxOf**

# MaxOf

Returns the largest value in an array, or NaN if it is empty.

## Syntax

```freebasic
MaxOf( byref a as Array( of T ) ) as float64
```

## Notes

- The array counterpart of `Max`, which takes two values.
- An empty array gives NaN.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print MaxOf( a )          '' 6
print MaxOf( a ) - MinOf( a ) = Range( a )   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
