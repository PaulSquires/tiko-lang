# Types

Every value in a tiko program has a type, and every variable keeps the type
it was declared with. The compiler knows all of them before the program runs,
so it can check that each operation makes sense and convert between number
types where one is needed.

```tiko
{{#include ../../examples/types/types.tiko}}
```

**Output**

```text
{{#include ../../examples/types/types.out}}
```

`items * unitPrice` multiplies an `int32` by a `float64`. The `int32` is
converted to `float64` first, so `cost` is a `float64` and keeps the half.
Going the other way, from `cost` into the `int32` called `rounded`, the value
is converted on assignment; a floating-point value assigned to an integer is
rounded, and 7.5 becomes 8.

Numbers and text do not convert into each other by themselves:

```tiko
{{#include ../../examples/types/mixing.tiko}}
```

```text
mixing.tiko(4,1): error TKO0702: a string and a number do not convert into each other
     |
   4 | label = items      '' refused: a number is not text
     | ^
```

`str( )` makes the conversion explicit, and `&` makes it for you: it turns
each operand into text and joins them.

The rest of this section covers [casting](casting.md) from one type to
another, the type each [literal](literals.md) has, letting the compiler
[infer](inference.md) a type, giving a type another name with an
[alias](aliasing.md), and the [sizes](sizes.md) of types in memory.
[Conversion](../conversion/index.md) goes further into numbers and text.

### Activities

1. Change `items` to a `float32` and print `sizeof( cost )`.
2. Assign 6.5 to `rounded` and print it. Is it 6 or 7?
