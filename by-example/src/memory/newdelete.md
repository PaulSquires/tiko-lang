# new and delete

`new T` allocates one `T` on the heap and returns a typed pointer to it;
`new T[ n ]` allocates `n` of them. There is no `sizeof` to get wrong and no
cast, and memory from `new` starts zeroed.

```tiko
{{#include ../../examples/memory/newdelete.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/newdelete.out}}
```

- `new int32( 42 )` allocates and initialises a single value.
- `new float64[ 3 ]` allocates three, all `0` until set: `several[1]` was
  never written and prints `0`.
- `new Point( 3, 4 )` fills a constructor-less type's fields in order, as
  `dim pt as Point = ( 3, 4 )` would.
- For `Tracked`, which has a constructor, `new Tracked[ 2 ]` runs it once per
  element, and `delete[]` runs the destructor once per element, last element
  first.

**Pair them exactly.** Memory from `new` goes back with `delete`, memory from
`new[]` with `delete[]`, and memory from `allocate` with `deallocate`. Mixing
the families is undefined behaviour; once a type has a destructor, only the
matching form runs it the right number of times.

A type whose only constructor takes arguments cannot be made with `new T[ n ]`:
there are no arguments to give each element, and the compiler says
`TKO0657: the type of '...' has no constructor that takes no argument`.

Every `new` needs a `delete` on every path through the program, and the pages
that follow show the tools that make that automatic: [destructors](raii.md),
[defer](defer.md) and [shared pointers](shared.md).

### Activities

1. Give `Tracked` a second field and initialise it in the constructor.
2. Allocate a `Point` with `new Point` and no arguments, and print its fields.
