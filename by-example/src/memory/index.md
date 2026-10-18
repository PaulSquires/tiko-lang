# Memory and Resources

Most values in a tiko program live where the compiler puts them: in the frame
of the procedure that declares them, created when the declaration runs and
destroyed when the block ends. That is the *stack*, and it needs no help from
you. When a value has to outlive the block that made it, or its size is known
only at run time, you ask for memory on the *heap*, and giving it back becomes
your job.

```tiko
{{#include ../../examples/memory/lifetimes.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/lifetimes.out}}
```

`MakeOnHeap` makes two `Counter`s. `onStack` is a local: its destructor runs
at `end function`, which is why "gone 4" appears before the caller prints
anything. The one made with `new` lives on the heap, so it survives the
return, and the caller destroys it with `delete` when it has finished.

| | Stack | Heap |
|---|---|---|
| made by | `dim`, `var`, parameters | `new`, `allocate` |
| destroyed | at the end of its block, automatically | by `delete` or `deallocate` |
| reached through | its name | a pointer |
| a mistake looks like | rare | a leak, or a use after free |

The pages in this section, from raw to managed:

- [Pointers](pointers.md): `ptr`, `@`, `*`, `->` and pointer arithmetic.
- [new and delete](newdelete.md): typed heap allocation.
- [nullptr](nullptr.md): the null pointer, and what `-exx` does with it.
- [References](references.md): `byref` variables and results.
- [Destructors and scope](raii.md): cleanup that runs by itself.
- [defer for cleanup](defer.md): freeing on every way out.
- [Non-copyable types](noncopy.md): one owner for one resource.
- [Shared pointers](shared.md): `SharedPtr` and `WeakPtr`.

### Activities

1. Remove the `delete kept` line. Which line of output disappears?
2. Make `MakeOnHeap` return `@onStack` instead. Why is that wrong, even if it
   seems to work?
