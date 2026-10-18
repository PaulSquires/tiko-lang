# Generics

A procedure that finds the larger of two values is the same code for
integers, floating-point numbers and strings. A *generic* lets you write it
once, with a placeholder for the type, and the compiler builds a separate,
fully checked version for each type you use it with.

```tiko
{{#include ../../examples/generics/largest.tiko}}
```

**Output**

```text
{{#include ../../examples/generics/largest.out}}
```

`( of T )` after the procedure's name declares a *type parameter*, `T`, and
from then on `T` can appear anywhere a type can: in the parameters, the result
and the body. Each call above passes two values of one type, so the compiler
works out `T` from the arguments and builds `Larger` for that type.

The result is as fast and as strictly typed as a version you wrote by hand for
each type: there is no conversion to a common type and no check at run time.
What you pay is code size, since each distinct `T` is a separate copy.

This section covers:

- [Generic types](types.md): a `Stack` that holds any element type.
- [Explicit type arguments](explicit.md): writing `( of T )` yourself, and
  naming an instantiation with `type ... as`.
- [What a type parameter asks for](constraints.md): the error you get when a
  type lacks an operator the generic uses.
- [Library demands: Hashable keys](hashable.md): making your own type a `Map`
  key.
- [Generics and lambdas](lambdas.md): passing any callable to a generic.

### Activities

1. Write `Smaller( of T )` and call it with three different types.
2. Call `Larger` with a `ustring` variable and a string literal, and read the
   error. What does it tell you about how `T` is chosen?
