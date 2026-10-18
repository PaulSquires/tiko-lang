# Tuples

A tuple groups two or more values into one, without declaring a type for
them first. It is the quick way to keep a pair together, or to give a
function more than one result.

```tiko
{{#include ../../examples/primitives/tuples.tiko}}
```

**Output**

```text
{{#include ../../examples/primitives/tuples.out}}
```

`( 7, 2.5 )` is a tuple value. Its elements are reached by position as
`_1`, `_2` and so on; `var` gives `pair` the tuple's type, here an `integer`
and a `float64`.

A tuple *type* is written in parentheses too: `( x as float64, y as float64 )`
has two elements called `x` and `y`. The names are for reading; the
positional names `_1` and `_2` still work, as the `_1` on the second line
shows. Elements can be assigned to one at a time.

`DivMod` returns `( quotient as int32, remainder as int32 )`. The `return`
builds the tuple, and the caller reads the parts by the names the function
gave them. A tuple returned this way replaces the extra `byref` parameter a
function would otherwise need for its second result.

Two tuples of the same element types compare with `=` and `<>`, element by
element. They have no ordering: `a < b` is error
`TKO0720: no operator < compares this type`. Nor can `print` take a whole
tuple; for a pair of integers it reports
`TKO0871: a '(integer, integer)' has no printable form`. Print the elements
instead.

Taking a tuple apart into separate variables in one line,
`var ( q, r ) = DivMod( 17, 5 )`, is covered in
[Tuples and Iterators](../iterators/index.md).

### Activities

1. Write a function that returns the smallest and largest of three
   `int32` values as a tuple with named elements.
2. Store three tuples of `( ustring, int32 )` in variables and print the
   one with the largest second element.
