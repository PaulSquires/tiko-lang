[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinOf**

# MinOf

Returns the smallest value in an array, or NaN if it is empty.

## Syntax

```freebasic
MinOf( byref a as Array( of T ) ) as float64
```

## Notes

- Distinct from `Min`, which compares two values -- this reduces an array.
- An empty array gives NaN.
- `Range` is `MaxOf` minus this.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print MinOf( a )          '' 2
print MaxOf( a )          '' 6
print Range( a )          '' 4 -- the difference
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
