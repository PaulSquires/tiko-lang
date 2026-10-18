# OrderedMap and OrderedSet

`containers.OrderedMap( of K, V )` and `containers.OrderedSet( of T )` keep
their contents **sorted** by key, always. They are trees rather than hash
tables, so each operation costs O(log n) instead of O(1), and in exchange they
answer questions about order that a `Map` or `Set` cannot.

```tiko
{{#include ../../examples/containers/ordered.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/ordered.out}}
```

The departures went in as 1430, 905, 1215, 1750 and come out of `for each` in
key order. An `OrderedMap` has the same members as a [`Map`](map.md) (`[ ]`,
`Add`, `Put`, `TryGet`, `Contains`, `Remove`, `Keys( )`, `Values( )`,
`Pairs( )`) and the indexer inserts on a miss here too. It adds four that only
make sense when the keys are in order:

| Member | Finds |
|---|---|
| `TryFirst( k, v )`, `TryLast( k, v )` | the smallest and the largest entry |
| `TryFloor( x, k )` | the largest key at or below `x` |
| `TryCeiling( x, k )` | the smallest key at or above `x` |

Each returns `false` when there is no such entry. `x` need not be a key itself:
"the next train after 13:00" is `TryCeiling( 1300, t )`.

An `OrderedSet` is the same tree with no values: `Add`, `Contains`, `Remove`,
the [set operations](set.md), and `TryFirst`, `TryLast`, `TryFloor` and
`TryCeiling` with one value instead of two.

The ordered containers need only `<` on the key, not a hash. Reach for them
when you need the order; for plain lookup, the hashed ones are faster.

### Activities

1. Print the departures between 1200 and 1500 by starting at
   `TryCeiling( 1200, t )` and stepping with `TryCeiling( t + 1, t )`.
2. Remove "York" with `Remove( 905 )` and print `TryFirst` again.
