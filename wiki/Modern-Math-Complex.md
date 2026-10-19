[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Complex**

# Complex

Holds a complex number as two Doubles, re and im.

## Syntax

```freebasic
type Complex
    as float64 re, im
end type
```

## Notes

- **Sixteen bytes, `float64` only.** There is no single-precision `Complexf`. Both libraries this header draws on are double-only, and a single-precision complex buys nothing at 16 bytes versus 8 unless the consumer is an FFT holding millions of them.
- The fields are named `re` and `im` and may be read directly, but `CReal` and `CImag` are the documented spelling — they survive a field rename and they say at the call site that the operand is complex.
- Positional initialisation works — `type<Complex>( 3, 4 )` — and agrees exactly with `CSet( 3, 4 )`.
- **No ordering operators.** `<` on complex numbers has no meaning, so none is defined. `=` and `<>` are.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( z )                      '' 3+4i
print sizeof( Complex )                   '' 16   -- two doubles, no padding
print CToString( type<Complex>( 3, 4 ) )  '' 3+4i   -- the positional form agrees
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
