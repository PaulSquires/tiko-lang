# Enums

An `enum` gives names to a set of related integer constants. Code that says
`Blue` instead of `10` explains itself, and the enum's name doubles as a type
for variables and parameters that hold one of the values.

```tiko
{{#include ../../examples/custom-types/enums.tiko}}
```

**Output**

```text
{{#include ../../examples/custom-types/enums.out}}
```

The first member is 0 unless it is given a value, and each member after it is
one more than the one before. `Blue = 10` restarts the count, so `Violet` is
11.

A member can be written on its own, `Green`, or qualified with the enum's
name, `Colour.Blue`. Plain names are shorter, but when two enums share a
member name only the qualified form says which one you mean. An `explicit`
enum must
always be qualified: in the `Level` example, a bare `High` is error
`TKO0743: 'high' is not declared`. That makes short member names safe.

Enum values are integers. They print as numbers, compare with `=` and `<`,
take part in arithmetic, and convert to an `int32` without a cast.
`select case` with one `case` per member is the usual way to act on one.

```admonish danger title="Pitfall"
**An enum variable accepts any integer.** `wall = 42` compiles even though no
member of `Colour` is 42. That is why `Describe` has a `case else`: a value
that arrived from a file or a calculation may not be a member at all.
```

### Activities

1. Add `Orange` between `Red` and `Green` and predict every value printed.
2. Write a function that returns the `Level` one step above its argument,
   staying at `High` at the top.
