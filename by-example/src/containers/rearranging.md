# Rearranging

Free procedures in `std/containers` that rearrange an `Array` in place — and
two that answer "the k smallest" or "the median" without paying for a full
sort.

```tiko
{{#include ../../examples/containers/rearranging.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/rearranging.out}}
```

| Procedure | Leaves the array |
|---|---|
| `ReverseArray( xs )` | in reverse order |
| `RotateArray( xs, k )` | rotated left by `k`; negative `k` rotates right |
| `Dedup( xs )` | without **consecutive** repeats; returns how many it removed |
| `NextPermutation( xs )` | in the next ordering; `false` after the last |
| `PartialSort( xs, k )` | with the `k` smallest at the front, sorted |
| `NthElement( xs, k )` | with at `xs[ k ]` what a full sort would put there |

`Dedup` only removes runs of equal neighbours, which is why the example sorts
first. `NextPermutation` steps through the orderings in sorted order, so start
from a sorted array to visit every one; `do ... loop while` runs the body once
before the first test.

`ReverseArray` and `RotateArray` carry the type in their names because
`std/strings` has a `Reverse` and `std/numeric` a `Rotate` of their own. The
procedures that compare have a `...By` form taking a comparer.

### Activities

1. Rotate by -1 instead of 2 and predict the result.
2. Start the permutation loop from `{ 2, 1, 3 }`. Which orderings are missed?
