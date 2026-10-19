[Home](Home) › [All Categories](Categories) › **PriorityQueue**

# PriorityQueue

A **priority queue** hands its elements back smallest first, whatever order they went in. Push work items, jobs or events as they arrive; `Pop` always gives you the one that should come next.

The example below queues four tasks by priority number and takes them back in order:

```freebasic
#import "std/containers"
using containers

dim q as PriorityQueue( of long )
q.Push( 5 )
q.Push( 1 )
q.Push( 3 )
q.Push( 2 )

while q.IsEmpty( ) = false
    print q.Pop( )                    ' 1, 2, 3, 5
wend
```

It is a **binary heap** stored in an [Array](Category-Array): `Push` and `Pop` are O(log n), `Peek` is O(1).

## Smallest First

`PriorityQueue( of T )` orders by `T`'s own `<`, so any type with a `<` works — numbers, `ustring`, or your own type with an `operator <`. The element nothing compares less than leaves first.

## Any Other Order: PriorityQueueBy

For largest first, or for any other order, give a comparer. `less( a, b )` returns `true` when `a` must leave **before** `b` — the same rule as [SortBy](Category-Sorting):

```freebasic
#import "std/containers"
using containers

type LongLess as function( byref x as long, byref y as long ) as boolean

dim later as LongLess = function( byref x as long, byref y as long ) as boolean
    return x > y
end function

dim q as PriorityQueueBy( of long, LongLess ) = PriorityQueueBy( of long, LongLess )( later )
q.Push( 4 )
q.Push( 11 )
q.Push( 2 )
print q.Pop( )                        ' 11 -- largest first
```

The second type argument is the comparer's type. For a plain lambda or `@MyProc` that is a procedure-pointer type, as above. A **capturing** lambda has a type of its own, written `typeof( name )`:

```freebasic
#import "std/containers"
using containers

dim as long comparisons = 0
var counted = function[ byref comparisons ]( byref x as long, byref y as long ) as boolean
    comparisons += 1
    return x < y
end function

dim q as PriorityQueueBy( of long, typeof( counted ) ) = _
    PriorityQueueBy( of long, typeof( counted ) )( counted )
q.Push( 3 )
q.Push( 1 )
print q.Pop( ), comparisons           ' 1  and the number of comparisons made
```

The queue keeps the comparer in a field, so a capturing lambda's `byref` captures must outlive the queue.

## Building From An Array

`MakeHeap( a )` builds a queue from an array's elements in O(n), cheaper than pushing them one at a time. The array itself is not changed.

```freebasic
#import "std/containers"
using containers

dim a as Array( of long ) = { 9, 4, 7, 1 }
dim q as PriorityQueue( of long ) = MakeHeap( a )
print q.Pop( ), q.Pop( )              ' 1  4
```

## Things To Know

- **Equal priorities leave in no particular order.** A heap is not stable. When order among equals matters, add a sequence number to the element and compare on it second.
- **Empty queue:** `Pop` returns a default value (0, `""`), as `Array.Pop` does. `TryPop( v )` returns `false` instead and leaves `v` alone. `Peek` on an empty queue is unspecified — test `IsEmpty` first.
- **`for each`** walks the elements in heap order, which is **not** priority order. `ToSortedArray( )` gives priority order without changing the queue.

## Members

```freebasic
Push( byref v as T )                            O(log n)
Pop( ) as T                                     O(log n)  removes and returns the first
TryPop( byref v as T ) as boolean               O(log n)
Peek( ) byref as T                              O(1)      the first, not removed
Count( ) as long                                O(1)
IsEmpty( ) as boolean                           O(1)
Clear( )                                        O(n)
Reserve( byval n as long )
ToSortedArray( ) as Array( of T )               O(n log n), a copy
GetIterator( ) as ArrayIterator( of T )         heap order

MakeHeap( byref a as Array( of T ) ) as PriorityQueue( of T )     O(n)
```

`PriorityQueueBy( of T, TLess )` has the same members and a constructor taking the comparer.

## See Also

[Array](Category-Array) · [Deque](Category-Deque) · [Sorting](Category-Sorting) · [Searching](Category-Searching)
