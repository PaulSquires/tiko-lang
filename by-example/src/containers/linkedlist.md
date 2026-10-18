# LinkedList

`containers.LinkedList( of T )` is a chain of elements that adds and removes at
**both ends** in constant time. That makes it a queue, a stack, or both at once
(a double-ended queue).

```tiko
{{#include ../../examples/containers/linkedlist.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/linkedlist.out}}
```

| Member | Does |
|---|---|
| `PushBack( v )`, `PushFront( v )` | add at the back or the front |
| `PopBack( )`, `PopFront( )` | remove and return from the back or the front |
| `Back( )`, `Front( )` | look at either end without removing |
| `Count( )`, `IsEmpty( )`, `Clear( )` | as for an `Array` |

A queue takes from the opposite end to the one it adds to, a stack from the
same end. `do until jobs.IsEmpty( )` is the loop that drains one.

Popping an empty list returns the element type's default value, 0 or an empty
string, rather than stopping the program. Test `IsEmpty( )` first when the
difference matters.

A `LinkedList` has no index: reaching the middle means walking to it with
`for each`. For most lists an [`Array`](array.md) is smaller and faster; use a
`LinkedList` when you need the front end too.

### Activities

1. Turn the undo stack into a queue by changing one call, and predict the
   output first.
2. Fill a list with five numbers, sort it with `containers.SortList`, and print
   it.
