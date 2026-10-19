[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Ulp**

# Ulp

Returns the gap between a number and the next one its type can hold.

## Syntax

```freebasic
Ulp( byval x as float64 ) as float64
```

## Notes

- Unit in the Last Place: the spacing of the floating-point grid **at this magnitude**, which grows as the magnitude does.
- It is how an error bound is stated meaningfully -- "within 2 ulp" means something at 1e300 and at 1e-300, where "within 1e-15" does not.
- Overloaded on `float64` and `float32`, and the answer differs between them because the grids differ.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Ulp( 1.0 ) > 0         '' -1 (true)

'' The grid gets coarser as the magnitude grows
print Ulp( 1e300 ) > Ulp( 1.0 )               '' -1 (true)

'' Adding less than half an ulp changes nothing
print ( 1.0 + Ulp( 1.0 ) / 4 ) = 1.0          '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
