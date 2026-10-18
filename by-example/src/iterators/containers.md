# for each over containers

`for each` works the same way over the standard library's containers as over
an array: it declares the loop variable, visits every element, and ends with a
plain `next`. The basic forms over arrays are on the
[for each](../flow/foreach.md) page; this page shows what each container
yields.

```tiko
{{#include ../../examples/iterators/containers.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/containers.out}}
```

| Container | `for each` yields |
|---|---|
| `Array( of T )` | each `T`, in index order |
| `OrderedSet( of T )` | each member, in sorted order, each once |
| `OrderedMap( of K, V )` | a record with fields `key` and `value`, in key order |
| `.Pairs( )` of a map | a `(key, value)` tuple, ready to destructure |

`for each byref p` binds the element itself, so `p *= 10` changes the array.
Without `byref` the loop variable is a copy. A container whose iterator hands
out copies refuses `byref`: over an `OrderedMap` it is
`TKO0818: 'for each byref' needs a byref Value( )`.

`for each (who, age) in ages.Pairs( )` declares one variable per element of
each tuple. The names are copies, and the list form takes neither `as` nor
`byref`.

The plain `Map` and `Set` are walked the same way, but in an order you must not
depend on. Use the ordered versions when the order is part of the output.
[Containers](../containers/index.md) covers each one.

### Activities

1. Walk `ages.Keys( )`, an `Array` of the keys, and print each key.
2. Add 1 to every age. `for each byref` over the map is refused, so walk
   `ages.Keys( )` and write through `ages[ k ]`.
