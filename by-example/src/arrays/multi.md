# Multi-dimensional arrays

A table, a board or an image has rows and columns. An array declared with two
ranges has two subscripts, one per dimension:

```tiko
{{#include ../../examples/arrays/multi.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/multi.out}}
```

The dimensions are separated by commas, both in the declaration and at each
use: `grid( r, c )`. `lbound` and `ubound` take the dimension number as a
second argument, so `ubound( grid, 2 )` is the last column. `ubound( grid, 0 )`
is the number of dimensions.

A brace list has one level of braces per dimension. The first inner list is
row 1, the second row 2.

Which loop goes outside is your choice and decides the order of the work: rows
outside to print the grid, columns outside to total each column. The elements
are stored row by row, with the **last** subscript changing fastest, so the
loop over the last subscript is the fastest one to put innermost on a large
array.

A dynamic array can have several dimensions too, declared with `( any, any )`
and sized by `redim`. The memory order matters there:

```tiko
{{#include ../../examples/arrays/multiredim.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/multiredim.out}}
```

````admonish danger title="Pitfall"
`redim preserve` keeps the elements in their memory order, not at their
indexes. Adding a row keeps every element where it was. Adding a column does
not: the old values run on into the new column, so `21` ends up at row 1,
column 4. To widen a grid, make a new one and copy the elements across by
index.
````

### Activities

1. Build a 10 by 10 multiplication table and print it.
2. Add a row-totals column to the first example's output.
