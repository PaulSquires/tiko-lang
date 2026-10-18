# Overloading

Several procedures may share one name when their parameter lists differ. Mark
each one `overload`, and at each call the compiler picks the version whose
parameters fit the arguments best:

```tiko
{{#include ../../examples/procedures/overload.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/overload.out}}
```

The versions can differ in the number of parameters, as the two-argument
`Describe` does, or in their types. An argument that matches no version
exactly is converted: `small` is an `int16`, and the `int32` version is the
cheapest conversion, so that one runs.

`overload` is what makes the shared name legal. Two procedures of the same
name with `overload` on neither are refused with
`TKO0600: 'describe' is already declared in this scope`, the same error as any
duplicate name, because most repeated names are mistakes.

When two versions fit equally well, the compiler refuses to guess:

```tiko
{{#include ../../examples/procedures/ambiguous.tiko}}
```

```text
ambiguous.tiko(10,5): error TKO0660: the call to 'show' matches more than one overload
```

`Show( 1, 2 )` needs one `int32` converted to `float64` whichever version is
chosen. Passing `1, 2.0` would pick the first version.

### Activities

1. Add a `Describe` for `boolean` and call it with `true`.
2. Change one argument in `ambiguous.tiko` so that the call picks the second
   version.
