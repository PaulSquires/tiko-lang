# Inference

`var` declares a variable without naming its type: the compiler works the
type out from the starting value. `typeof` goes the other way and gives you
the type of an expression, to use wherever a type is expected.

```tiko
{{#include ../../examples/types/inference.tiko}}
```

**Output**

```text
{{#include ../../examples/types/inference.out}}
```

`var` copies the type of the value exactly. `count` is an `integer` because a
plain whole-number literal is one, and `tiny` is a `uint8` because the cast
says so. The value can be any expression: `mean` takes the `float64` that
`Average` returns, and `total` the `float64` that an integer times a
`float64` produces.

Arithmetic on integers narrower than `integer` is carried out at `integer`
width, so `a + b` on two `int16`s is an 8-byte result, and 60000 does not
overflow. Assign it back to an `int16` and it would.

`typeof( tiny )` stands for `uint8` in the declaration of `other`. That is
useful when a variable must match another one whose type might change later.

Inference happens once. After `var tiny = cast( uint8, 7 )`, `tiny` is a
`uint8` for good, and `255 + 1` wraps to 0 in it.

```admonish note
For text, write the type: `dim as ustring title = "report"`. A string
literal on its own is the 8-bit legacy `string` type, and `var` copies that,
so `var title = "report"` does not give you a `ustring`.
```

### Activities

1. Declare `var half = 1 / 2` and print `sizeof( half )` and `half`.
2. Declare `dim as typeof( mean ) spread = 0` and check its size.
