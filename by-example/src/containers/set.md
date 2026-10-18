# Set

`containers.Set( of T )` holds each value at most once and answers "is it in?"
in constant time on average. It is a [`Map`](map.md) with keys and no values.

```tiko
{{#include ../../examples/containers/set.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/set.out}}
```

`Add` returns `true` when the value is new and `false` when it was already
there, so `if seen.Add( x ) then` is the natural way to do something once per
distinct value. `Contains` asks without changing anything, and `Remove` returns
whether there was something to remove.

| Operation | Leaves in the set |
|---|---|
| `a.IntersectWith( b )` | the values in both `a` and `b` |
| `a.UnionWith( b )` | the values in either |
| `a.ExceptWith( b )` | the values in `a` that are not in `b` |

The three operations change the set they are called on. Declaring
`dim both as containers.Set( of int32 ) = evens` copies `evens`, so the example
can apply each operation to a fresh copy and `evens` itself is unchanged at the
end.

Like a `Map`, a `Set` has no order. `Items( )` copies the values into an
`Array`, which `Show` sorts before printing. When you want the values kept in
order all the time, use an [`OrderedSet`](ordered.md).

### Activities

1. Use a `Set( of ustring )` to print each distinct word of a sentence once.
2. Compute the values in exactly one of `evens` and `small` (the symmetric
   difference) from the operations above.
