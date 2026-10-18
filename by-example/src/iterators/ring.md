# An iterable generic collection

With [generics](../generics/types.md), an iterator is written once for every
element type. A ring buffer keeps the newest N values and forgets the oldest,
and `for each` walks what it holds, oldest first:

```tiko
{{#include ../../examples/iterators/ring.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/ring.out}}
```

`Ring( of T ).GetIterator( )` returns a `RingIterator( of T )`, an
instantiation of a *different* generic. That is the usual shape, and the one
the standard containers use. The iterator holds a pointer to the storage,
where to start and how many elements are left; it knows nothing about how they
got there.

Because `Value( )` is declared `byref as T`, it hands out the stored element
itself, so `for each byref x in readings` doubles the numbers inside the ring.
An iterator whose `Value( )` returns by value would refuse that loop with
`TKO0818`.

After five words go into a ring of three, only the newest three are left.
`readings` has room for four but holds two, and the walk visits exactly two:
`left` starts at the number in use, so the empty slots are never seen.

### Activities

1. Add a `Count( )` method to `Ring` and print it after each `Add`.
2. Walk a `Ring( of int32 )( 2 )` that has never had anything added. How many
   times does the body run?
