# Collection initialisers

A brace list after a container's declaration gives it its starting elements,
the same way an ordinary array takes one:

```tiko
{{#include ../../examples/containers/initialisers.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/initialisers.out}}
```

The list becomes one call per element, made right after the container is
constructed: `Push` for an `Array`, `Add` for a `Set`, `PushBack` for a
`LinkedList`. So the `Set` counts two tags, because `Add` ignores the repeated
`"new"`, and the elements can be any expressions, such as `w * h`.

For a `Map` or an `OrderedMap`, each element is itself a brace pair,
`{ key, value }`, and the pair becomes the two arguments of one `Add`.

Nothing about this is special to the standard containers. `Tally` has a
constructor and an `Add` member, so it takes a brace list as well, and each
element is passed to `Add` in turn.

A brace list belongs to the declaration. Assigning one later is refused:

```tiko
{{#include ../../examples/containers/initassign.tiko}}
```

```text
initassign.tiko(4,10): error TKO0846: a '{ ... }' list can only initialize an array, and nothing here is one
```

To refill a container, `Clear( )` it and push the new elements.

### Activities

1. Declare a `Map( of ustring, int32 )` of three colours with a brace list and
   print its sorted keys.
2. Give `Tally` a `Push` member instead of `Add` and check it still takes a
   brace list.
