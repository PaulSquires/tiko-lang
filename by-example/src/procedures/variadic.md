# Variadic procedures

Some procedures make sense with any number of arguments: a total, a join, a
maximum. A **typed variadic** parameter takes them all. Write `...` after its
type, and the caller writes a plain list:

```tiko
{{#include ../../examples/procedures/variadic.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/variadic.out}}
```

Inside the procedure, `values` is an ordinary array: `for each` walks it, and
`lbound` and `ubound` give its bounds. With no arguments the array is empty,
so `Total( )` is 0 and `Join( ", " )` is an empty string without any special
case in the code.

The variadic parameter must be the last one; anything else is
`TKO0973: a typed variadic parameter ('...') must be the last parameter`.
Fixed parameters, like `Join`'s separator, come before it.

Each argument is converted to the element type exactly as it would be for an
ordinary parameter, so `small` (an `int16`) and `5.0` are accepted where
`int32` is wanted. An argument that does not convert is a compile error at that
argument.

An array of the element type can stand for the whole list, as `week( )` does.
It is passed as it is, without copying.

```admonish danger title="Pitfall"
Declare the parameter `as const` unless the procedure is meant to write to it.
A list of arguments is packed into a temporary array, but an array passed as
the whole list is the caller's own, so a procedure that writes to its
variadic parameter changes the caller's array in one case and nothing in the
other.
```

```admonish warning title="Status in this version"
`as const` on a variadic parameter is not yet enforced: an assignment to one
of its elements compiles, and, when a whole array was passed, changes the
caller's array. [Passing arrays](../arrays/passing.md) has the same issue for
ordinary array parameters.
```

### Activities

1. Write `function Largest( values( ) as const int32 ... ) as int32`. Decide
   what it should return when called with no arguments.
2. Call `Join` with a separator of `" and "` and four words.
