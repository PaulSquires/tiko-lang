# Constants

`const` names a value that is fixed when the program is compiled. A name
such as `MaxUsers` says what a number is for, and changing it means editing
one line rather than hunting for every `100`.

```tiko
{{#include ../../examples/custom-types/constants.tiko}}
```

**Output**

```text
{{#include ../../examples/custom-types/constants.out}}
```

A `const` without a type takes the type of its value, by the same rules as a
[literal](../types/literals.md): `MaxUsers` is an 8-byte `integer` and `Pi` a
`float64`. With `as T` the value is converted to that type, so `Small` is a
one-byte `uint8` and `Ratio` a `float32`.

A constant's value can be an expression over other constants, worked out by
the compiler. That makes constants usable where the compiler needs a fixed
number, such as the bounds of a fixed-size array: `board( 1 to Cells )`.

A constant declared inside a block, as `Greeting` is inside `scope`, exists
only in that block; using it after `end scope` is error
`TKO0743: 'greeting' is not declared`. Assigning to any constant is refused,
as [Mutability](../variables/mutability.md) shows, which also covers
`dim as const` for values computed while the program runs.

### Activities

1. Add `const Area = Rows * Cols` and use it to declare a second array.
2. Declare `const Label as ustring = AppName & " v2"` and print it.
