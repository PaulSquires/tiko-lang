# Rounding

When a value with a fraction becomes a whole number, something has to decide
what happens to the fraction. tiko's built-in conversions round to the
nearest integer, and send an exact half to the **even** neighbour. Other
rules are a function call away.

```tiko
{{#include ../../examples/conversion/rounding.tiko}}
```

**Output**

```text
{{#include ../../examples/conversion/rounding.out}}
```

| Function | Rule | 2.5 | -2.5 | 2.6 |
|---|---|---|---|---|
| `cint`, `cast`, assignment | nearest, half to even | 2 | -2 | 3 |
| `int` | down, towards minus infinity | 2 | -3 | 2 |
| `fix` | towards zero, dropping the fraction | 2 | -2 | 2 |
| `numeric.Round` | nearest, half away from zero | 3 | -3 | 3 |
| `numeric.RoundHalfEven` | nearest, half to even | 2 | -2 | 3 |

```admonish danger title="Pitfall"
**Converting a float to an integer rounds; it does not truncate.**
`cint( 2.6 )` is 3, and so is `dim as int32 n = 2.6`. And half goes to the
even neighbour, so `cint( 2.5 )` is 2 while `cint( 3.5 )` is 4. When you
want the fraction dropped, use `fix`; when you want halves rounded up, use
`numeric.Round`.
```

`int` and `fix` give a `float64` when they are given one, not an integer, so
`fix( -0.5 )` is negative zero and prints as `-0`. Assign the result to an
integer variable when you need one.

`numeric.Floor` and `numeric.Ceil` round down and up, and
`numeric.Round( x, n )` rounds to `n` digits after the point.
[Numbers](../numbers/index.md) has the rest of `std/numeric`.

### Activities

1. Add 3.5 and -3.5 to `samples` and check each column.
2. Cut 2.71828 to two places with `fix( x * 100 ) / 100`, and compare the
   result with `numeric.Round( 2.71828, 2 )`.
