# Infinity, NaN and negative zero

A `float64` can hold more than numbers: positive and negative infinity, NaN
("not a number", the result of an operation with no answer), and a zero with a
sign. Floating point does not wrap on overflow; it goes to infinity.

```tiko
{{#include ../../examples/numbers/special.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/special.out}}
```

`numeric.Infinity( )`, `NegInfinity( )` and `NaN( )` make the special values.
They are functions because a constant cannot be initialised by dividing by zero.

**A NaN is not equal to anything, itself included**, so `x = x` is false for a
NaN. Ask `IsNaN( x )`. `IsInfinite`, `IsFinite`, `IsNormal` and `IsSubnormal`
complete the questions, and `Classify( x )` names the kind: `FP_NAN`,
`FP_INFINITE`, `FP_ZERO`, `FP_SUBNORMAL` or `FP_NORMAL`.

`-0.0` and `0.0` are equal as numbers and differ in the sign bit, which
`IsNegative` reads. The sign shows when you divide by it: one over negative
zero is negative infinity.

The library passes a NaN on rather than dropping it: `Max( NaN, 1 )` is NaN.
Losing the NaN there would turn an error you could find into a wrong answer you
could not.

The example prints tests of the values rather than the values. How `print`
shows an infinity or a NaN is the runtime's choice; a test means the same on
every platform.

### Activities

1. Print `IsNaN( sqr( -1 ) )`.
2. Find the smallest power of ten that is infinite in a `float64` with a loop
   and `IsInfinite`.
