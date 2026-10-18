# The numeric library

`#import "std/numeric"` adds the functions the built-ins lack, each named for
exactly what it does. Nothing existing changes: `int`, `mod` and `^` behave as
before, and the library adds correct neighbours under other names.

```tiko
{{#include ../../examples/numbers/library.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/library.out}}
```

**Rounding.** `Round` takes a half away from zero; `RoundHalfEven` takes it to
the even neighbour, which is banker's rounding. Both take an optional number of
decimal places. `Floor`, `Ceil` and `Truncate` say which way they go.

**Selection.** `Min`, `Max` and `Clamp( v, lo, hi )` work on every numeric
type; `Lerp( a, b, t )` moves from `a` toward `b` by the fraction `t`.

**Constants and functions.** `PI`, `TAU`, `E`, `SQRT2`, `LN2` and `LN10`; `Hypot`,
which does not overflow where `sqr( x * x + y * y )` would; `Log2`, `Log10`,
`Cbrt`, `Pow` and the hyperbolic functions.

**Whole numbers.** `IPow` multiplies integers, so it is exact where `^` rounds
(see [Overflow](overflow.md)). `ISqrt`, `GCD` and `LCM` are exact too.
`FloorMod` takes the sign of the divisor, so it is never negative for a positive
divisor: the remainder you want for wrapping an index around. `DivMod` returns
the quotient and remainder together as a tuple, which `var ( pages, rest ) = ...`
takes apart.

The module's names are reached through `numeric.`, or bare after
`using numeric`.

### Activities

1. Round 2.5, 3.5 and 4.5 with both `Round` and `RoundHalfEven`.
2. Use `FloorMod` to step backwards through the days of the week 0 to 6,
   starting at 2 and wrapping past 0.
