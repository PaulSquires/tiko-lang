# PriorityQueue

`containers.PriorityQueue( of T )` hands back its **smallest** element first,
whatever order the elements went in. Use it when the next item to handle is the
most urgent one, not the oldest.

```tiko
{{#include ../../examples/containers/priorityqueue.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/priorityqueue.out}}
```

`Push` and `Pop` cost O(log n); `Peek` looks at the next element without
removing it. Equal elements, like the two 3s, may leave in either order.

For any order other than smallest first, use
`containers.PriorityQueueBy( of T, TLess )` and give it a comparer when you
construct it. `less( a, b )` returns `true` when `a` must leave before `b` —
the question a [`SortBy`](sorting.md) comparer answers. The second type
argument is the comparer's type: the example names a procedure-pointer type,
`Bigger`, for a plain lambda. A capturing lambda's type is written
`typeof( name )`.

`for each` over a priority queue walks its internal order, which is **not**
priority order. Take elements with `Pop`, or call `ToSortedArray( )` for a
sorted copy.

### Activities

1. Loop over `deadlines` with `for each` before popping, and compare the order
   with the popped one.
2. Push records of a type with a `priority` field, ordered by a comparer.
