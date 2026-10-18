# Map

`containers.Map( of K, V )` stores a value under each key and finds the value
for a key in constant time on average, however many entries there are. It is a
hash table: the key is turned into a number that says where in the table its
entry lives.

```tiko
{{#include ../../examples/containers/map.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/map.out}}
```

| Member | Does |
|---|---|
| `m[ k ]` | the value for `k`, which can be assigned; **inserts a default value if `k` is absent** |
| `Add( k, v )` | inserts only if `k` is absent; `false` if it was there |
| `Put( k, v )` | inserts or replaces; `true` if `k` was new |
| `TryGet( k, v )` | `true` and the value in `v` if `k` is present |
| `Contains( k )` | whether `k` is present |
| `Remove( k )` | `true` if something was removed |
| `Keys( )`, `Values( )` | the keys or the values, copied into an `Array` |
| `Pairs( )` | `(key, value)` tuples, for `for each (k, v) in m.Pairs( )` |

A `Map` keeps **no order**. `for each kv in m` (with `kv.key` and `kv.value`)
visits the entries in the order the table holds them, which is neither the
order you inserted them nor sorted, and which changes as the map grows. To
print a map the same way every time, sort its `Keys( )` first, as the example
does, or use an [`OrderedMap`](ordered.md).

## Missing keys

`m[ k ] += 1` works on a key the map has never seen, because the indexer
inserts the value type's default, 0, before the `+= 1`. That is what makes
counting easy, and it has a cost when you only meant to look:

````admonish danger title="Pitfall"
```tiko
{{#include ../../examples/containers/mapmiss.tiko}}
```

```text
{{#include ../../examples/containers/mapmiss.out}}
```

Each `if stock[ ... ] = 0` printed the right answer and added an entry. The map
now holds four items where two were stocked, so a later `Count( )` or
`for each` is wrong. Use `[ ]` to write, and `TryGet` or `Contains` to read.
````

### Activities

1. Replace `ages[ "ada" ] = 37` with `ages.Put( "ada", 37 )` and print what
   `Put` returns.
2. Walk the map with `for each (who, age) in ages.Pairs( )` and see the order
   the table gives you.
