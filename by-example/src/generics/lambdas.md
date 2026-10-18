# Generics and lambdas

A procedure pointer has one fixed type, and a lambda that captures variables
cannot become one. A type parameter has no such limit: a generic with a
parameter `( of F )` accepts any value it can call, whether a procedure, a
lambda or a closure.

```tiko
{{#include ../../examples/generics/countif.tiko}}
```

**Output**

```text
{{#include ../../examples/generics/countif.out}}
```

`CountIf` has two type parameters. `T` is inferred from the array, and `F`
from whatever is passed as `test`. The only demand the body makes of `F` is
that `test( x )` compiles and gives something `if` can test.

- The first call passes a lambda written in place. It captures nothing.
- `overLimit` captures `limit` with `[ byval limit ]`, so it is a closure: a
  small object holding its own copy of `limit`. It can still be passed, because
  `F` becomes the closure's type.
- `Transform` takes a lambda that returns a new value, and `for each byref`
  writes it back into the array.
- With `words`, `T` is `ustring`, and the lambda's parameter is a `ustring` to
  match.

`F` is passed `byref`, so a closure is not copied on the way in. The standard
library's `containers.ForEach` is declared the same way. Lambdas themselves
are covered in [Procedures](../procedures/lambda.md).

### Activities

1. Write `Sum( of T, F )` that adds up `f( x )` for every element, and use it
   to total the squares of `nums`.
2. Capture `limit` with `byref` instead, change `limit` after creating
   `overLimit`, and compare the counts.
