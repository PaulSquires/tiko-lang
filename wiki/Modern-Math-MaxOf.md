[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MaxOf**

# MaxOf

Returns the largest value in an array, or NaN if it is empty.

## Syntax

```freebasic
MaxOf( a( ) as T ) as float64
```

## Notes

- The array counterpart of `Max`, which takes two values.
- An empty array gives 0.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print MaxOf( a( ) )          '' 6
print MaxOf( a( ) ) - MinOf( a( ) ) = Range( a( ) )   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
