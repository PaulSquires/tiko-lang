[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CNaN**

# CNaN

Returns a complex number whose two parts are both NaN.

## Syntax

```freebasic
CNaN( ) as Complex
```

## Notes

- **A function, not a constant**, and here there is no alternative: `const as Complex N = ( 0.0/0.0, 0.0/0.0 )` is a compile-time division by zero and does not compile. Same decision, same reason, as `NaN( )` in `math.tiko`.
- A NaN is not equal to itself, here as everywhere. Use `CIsNaN` to test for one, never `= CNaN( )`.
- **A number with one infinite part and one NaN part is not this.** It is *infinite* — see `CIsNaN`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CIsNaN( CNaN( ) )     '' true
print CNaN( ) = CNaN( )     '' false   -- never true, as for any NaN
print CToString( CNaN( ) )  '' nan+nani
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
