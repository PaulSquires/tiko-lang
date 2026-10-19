# Deque

`containers.Deque( of T )` — a double-ended queue, said "deck" — adds and
removes at **both ends** in constant time, like a
[`LinkedList`](linkedlist.md), and also reaches any element by index with
`d[ i ]`.

```tiko
{{#include ../../examples/containers/deque.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/deque.out}}
```

| Member | Does |
|---|---|
| `PushBack( v )`, `PushFront( v )` | add at the back or the front |
| `PopBack( )`, `PopFront( )` | remove and return from the back or the front |
| `TryPopBack( v )`, `TryPopFront( v )` | the same, returning `false` when empty |
| `Front( )`, `Back( )`, `d[ i ]` | look without removing; index 0 is the front |
| `Count( )`, `IsEmpty( )`, `Clear( )` | as for an `Array` |

The example keeps a bounded history: each page goes in at the back, and once
there are more than five the oldest comes off the front. `for each` walks from
front to back.

A `Deque` stores its elements in one block of memory used as a ring, which
doubles when it fills, so there is no allocation per element. Reach for it
before a `LinkedList` when you want a queue. `d[ i ]` needs an index from 0 to
`Count( ) - 1`; the deque does not grow to make a bad one valid.

### Activities

1. Make the history keep three pages instead of five, and predict the output
   first.
2. Declare a deque with a brace list, `= { 1, 2, 3 }`, and print it with
   `for each`.
