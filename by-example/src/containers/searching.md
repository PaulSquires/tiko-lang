# Searching

`containers.IndexOf( xs, v )` returns the index of the first element equal to
`v`, or -1 when there is none; `containers.Contains( xs, v )` says whether there
is one. Both look at the elements one at a time, from the front. On a
**sorted** array, `BinarySearch`, `LowerBound` and `UpperBound` halve the range
at each step instead: about 20 looks for a million elements.

```tiko
{{#include ../../examples/containers/searching.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/searching.out}}
```

| Procedure | Returns | Needs |
|---|---|---|
| `IndexOf( xs, v )` | first index equal to `v`, or -1 | `=` |
| `Contains( xs, v )` | whether there is one | `=` |
| `BinarySearch( xs, v )` | first index equal to `v`; on a miss, `-( insertion point ) - 1` | sorted, `<` |
| `LowerBound( xs, v )` | first index not less than `v` | sorted, `<` |
| `UpperBound( xs, v )` | first index greater than `v` | sorted, `<` |

A miss in `BinarySearch` is always negative, and `-( r + 1 )` turns it back
into the index where the value would go. `UpperBound` minus `LowerBound` counts
the copies of a value. The sorted searches trust the array to be sorted: on an
unsorted one they return some index without complaint. Each has a `...By` form
taking a comparer, for an array sorted with `SortBy`.

These are free procedures rather than members of `Array` because they need `=`
or `<` on the element type. A member would demand that of every element type an
`Array` is ever declared with; a free procedure asks only where it is called.
When you search the same values often, an [`OrderedSet`](ordered.md) keeps them
sorted for you, and a [`Set`](set.md) answers `Contains` without searching.

## The value must have the element's type

The searches are generic, and their type is inferred from **both** arguments,
exactly. That is why the example puts 85, 60 and 90 in `int32` variables instead
of writing them as literals:

```tiko
{{#include ../../examples/containers/searchliteral.tiko}}
```

```text
searchliteral.tiko(4,26): error TKO0809: cannot infer the type arguments of 'contains'; write them, as 'contains( of ... )( ... )'
```

The literal `90` is an `integer`, and the array holds `int32`s, so no single
element type fits both. Pass a variable of the element type, or name the type
as the message suggests: `containers.Contains( of int32 )( scores, 90 )`.

### Activities

1. Search the sorted scores for 85 with `BinarySearch`, then with
   `UpperBound`. Which index does each give, and why?
2. Insert 75 at the position a missed `BinarySearch` reports, and print the
   array to check it is still sorted.
