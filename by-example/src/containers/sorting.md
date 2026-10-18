# Sorting

Sorting is done by free procedures in `std/containers`, not by members of
`Array`: `containers.Sort( xs )` sorts an `Array` in place.

```tiko
{{#include ../../examples/containers/sorting.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/sorting.out}}
```

`Sort` orders by the element type's own `<`. To order any other way, pass a
**comparer** to `SortBy`: a procedure, usually a lambda, that takes two
elements and returns `true` when the first must come **before** the second.
Return `false` for elements that are equal; a comparer such as `a >= b` breaks
that rule. A record type has no `<` of its own, so it always needs a comparer.

| Procedure | Sorts | Stable |
|---|---|---|
| `Sort( xs )`, `SortBy( xs, less )` | an `Array`, in place | no |
| `StableSort( xs )`, `StableSortBy( xs, less )` | an `Array`, in place | yes |
| `SortList( l )`, `SortListBy( l, less )` | a `LinkedList` | yes |
| `IsSorted( xs )`, `IsSortedBy( xs, less )` | nothing: they answer whether it is | |

A **stable** sort keeps elements that compare equal in the order they had
before. That is what the second sort relies on: the players are first put
best-first, then sorted by team with `StableSortBy`, and within each team the
best-first order survives. With the unstable `SortBy` for that second step, the
order within a team is whatever the algorithm leaves.

`Sort` is the faster of the two and is the one to use when stability does not
matter, which includes every sort of plain numbers or strings. Comparers and
lambdas in general are covered in [Procedures](../procedures/index.md).

### Activities

1. Sort the players by name, then print them.
2. Sort an `Array( of ustring )` by length, shortest first, with `SortBy` and
   `len( a ) < len( b )`.
3. Count the comparisons a sort makes with a capturing lambda,
   `function[ byref n ]( ... )`, that adds one to `n` on every call.
