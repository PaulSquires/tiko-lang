# for each over arrays

[for each](../flow/foreach.md) walks an array in index order without an index.
It has two forms, and the difference is whether you can change the elements:

```tiko
{{#include ../../examples/arrays/foreach.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/foreach.out}}
```

- `for each p in prices` hands you a **copy** of each element. Writing `p = 0`
  changes the copy, and the array is untouched.
- `for each byref p in prices` hands you the element itself, so `p += p \ 10`
  changes the array.

`byref` also avoids copying each element, which matters when the elements are
large, as records with text fields are. The `stock` loop sets a field of each
`Item` through the reference.

`for each` does not walk an array of more than one dimension:

```tiko
{{#include ../../examples/arrays/foreach2d.tiko}}
```

```text
foreach2d.tiko(4,1): error TKO0608: 'for each' over a multi-dimensional array has no defined order
```

Rows first or columns first is a decision the program should state, so the
compiler does not choose one. Write the two counting loops, as the last part of
the first example does, in the order you want.

### Activities

1. Use `for each byref` to round every price up to the next multiple of 25.
2. Find the `Item` with the largest `count` using `for each` and no index.
