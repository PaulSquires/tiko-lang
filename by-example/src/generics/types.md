# Generic types

A type can take type parameters too. A stack of integers and a stack of names
need the same fields and the same methods; only the element type differs.

```tiko
{{#include ../../examples/generics/stack.tiko}}
```

**Output**

```text
{{#include ../../examples/generics/stack.out}}
```

`type Stack( of T )` declares the parameter, and `T` is then used for the
element array and in the method signatures. A member written outside the type
repeats the parameter list: `sub Stack( of T ).Push( ... )`, with the same
parameter names as the declaration.

The name `Stack` on its own is not a type. You always write it with its
arguments, `Stack( of int32 )`, and each distinct argument list is a distinct
type: `Stack( of int32 )` and `Stack( of ustring )` are as unrelated as two
types you wrote separately, and one does not assign to the other. Writing
`Stack( of int32 )` twice gives the same type both times.

A type can take more than one parameter, as `Pair( of K, V )` does on the
[next page](explicit.md), and a type argument can itself be an instantiation:
`Stack( of Stack( of int32 ) )` is a stack of stacks.

### Activities

1. Add a `Peek( )` method that returns the top item without removing it.
2. Try to assign `numbers` to `words` and read the error.
3. Write a `Queue( of T )`, first in, first out, with `Enqueue` and `Dequeue`.
