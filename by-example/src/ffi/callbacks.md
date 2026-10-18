# Callbacks

Some C functions take a pointer to a function and call back into the program.
C's `qsort` sorts any array, and calls a comparison function you supply each
time it needs to order two elements.

```tiko
{{#include ../../examples/ffi/callbacks.tiko}}
```

**Output**

```text
{{#include ../../examples/ffi/callbacks.out}}
```

A tiko procedure can be the callback if it is **`cdecl`** and takes exactly the
parameters C passes, with the right types. `@Ascending` is its address. The
`type Compare as function cdecl( ... )` alias names the pointer type, so the
`qsort` declaration reads the way C's does.

`qsort` hands the comparison two `const any ptr`s to elements of the array, and
expects a negative number, zero or a positive number. `Ascending` compares
instead of subtracting, which cannot overflow; the lambda's subtraction is fine
for these small values.

A **lambda that captures nothing** is an ordinary function, so it converts to a
function pointer and can be passed straight to C. A lambda that captures
variables cannot: it carries the captured values with it, and C has nowhere to
put them. C's own way to pass state into a callback is the extra `void *`
parameter that most callback interfaces have, often called `user` or
`context`: pass a pointer to your data, and cast it back inside the callback.

Lambdas are covered in [Procedures](../procedures/index.md).

### Activities

1. Sort an array of `float64` values with `qsort`.
2. Sort the integers by their last digit.
