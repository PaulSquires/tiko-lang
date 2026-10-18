# Numbers

The everyday numeric functions are built in and need no import: absolute value,
square root, trigonometry, logarithms, rounding toward a whole number. Two of
them round in a direction their names do not announce, and that is what to
watch for.

```tiko
{{#include ../../examples/numbers/builtins.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/builtins.out}}
```

| Function | Gives |
|---|---|
| `abs( x )`, `sgn( x )` | the magnitude; -1, 0 or 1 |
| `sqr( x )` | the square root |
| `exp( x )`, `log( x )` | e to the power `x`, and the **natural** logarithm |
| `sin`, `cos`, `tan`, `asin`, `acos`, `atn`, `atan2` | trigonometry, in radians |
| `int( x )` | the largest whole number not above `x`: it rounds **down** |
| `fix( x )`, `frac( x )` | the whole part toward zero, and what is left |

`int( -2.5 )` is -3, because `int` is a floor; code that uses it believing it
truncates is wrong for every negative number. `fix` is the one that truncates.

`/` always divides as floating point. `\` divides whole numbers and `mod` gives
the remainder; both truncate toward zero, so the remainder takes the sign of
the left-hand side and `-7 mod 3` is -1. `^` raises to a power, working in
`float64`.

`sin( pi / 6 )` prints `0.4999999999999999` rather than `0.5`: `pi` holds the
nearest `float64` to pi, not pi itself. Results from the square root,
logarithms and trigonometry come from each platform's maths library.

The `std/numeric` module fills the gaps: rounding that names its direction,
exact integer arithmetic, overflow control, and more. The pages that follow use
it.

### Activities

1. Print `int( 2.7 )`, `int( -2.7 )`, `fix( 2.7 )` and `fix( -2.7 )`, and
   predict each before you run it.
2. Convert 90 degrees to radians and print its sine.
