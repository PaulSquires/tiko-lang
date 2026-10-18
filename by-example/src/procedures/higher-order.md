# Higher-order procedures

A procedure that takes another procedure as an argument is *higher-order*. It
decides when the work happens; the caller decides what the work is. To accept
plain lambdas and capturing closures alike, the parameter is a generic type:

```tiko
{{#include ../../examples/procedures/higherorder.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/higherorder.out}}
```

`Repeat( of F )` takes its action as `byref action as F`. `F` is whatever type
the argument has: here, the type of a closure that captures `sumOfSquares`.
Inside, `action( i )` calls it like any procedure.
[Generics](../generics/index.md) covers `of` in full.

The standard library's containers take callables the same way:

- `containers.SortBy` takes a **comparer** that answers one question, "does
  `a` come before `b`?". Answering `a > b` sorts from highest to lowest.
- `containers.ForEach` hands each element to an **action**. This one captures
  `passMark` by value, because it only reads it, and `passed` by reference,
  because it updates it.

A parameter typed as a procedure pointer, like `Tabulate`'s on the
[procedure pointers](procptr.md) page, takes only lambdas that capture
nothing; a closure passed to one is
`TKO0698: this argument does not convert to the parameter's type`. The generic
form takes both. [Containers](../containers/index.md)
lists the other procedures that take a callable.

### Activities

1. Write `function CountIf( of F )( values( ) as int32, byref test as F ) as int32`
   and use it with a lambda that tests for even numbers.
2. Sort `scores` from lowest to highest, then print only the three best.
