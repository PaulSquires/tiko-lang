[Home](Home) › [All Categories](Categories) › **Deque**

# Deque

A **deque** (say "deck", short for double-ended queue) is a sequence you can add to and take from at **both ends** quickly — and, unlike a [LinkedList](Category-LinkedList), reach any element by its position with `d[ i ]`.

```freebasic
#import "std/containers"
using containers

dim d as Deque( of ustring )
d.PushBack( "b" )
d.PushFront( "a" )
d.PushBack( "c" )

print d[ 0 ], d[ 2 ]                  ' a  c
print d.PopFront( )                   ' a
print d.PopBack( )                    ' c
print d.Count( )                      ' 1
```

Index 0 is the **front**. `for each` walks front to back.

A brace list fills one at the declaration: `dim d as Deque( of long ) = { 1, 2, 3 }` calls `PushBack` once per element. See [Collection Initializers](Category-Collection-Initializers).

## When To Use It

- A **queue** (first in, first out): `PushBack` to add, `PopFront` to take.
- A **sliding window**: push new items at the back, drop old ones from the front, and look at any of them by index.
- An **undo history** with a size limit: push at the back, drop the oldest from the front when full.

Every end operation is O(1) amortised, and indexing is O(1). The elements live in one ring-shaped block of memory that grows by doubling, so there is no allocation per element. Prefer it to [LinkedList](Category-LinkedList) unless you need an iterator that stays valid across insertions.

## Things To Know

- **Empty deque:** the `Pop` forms return a default value (0, `""`); `TryPopFront( v )` and `TryPopBack( v )` return `false` instead.
- **`d[ i ]`, `Front( )`, `Back( )`** need `0 <= i < Count( )`. Outside that range the value is unspecified; the deque does not grow to make the index valid.
- A Push may move elements in memory, so do not hold a reference from `d[ i ]` across a Push.

## Members

```freebasic
PushBack( byref v as T )                        O(1) amortised
PushFront( byref v as T )                       O(1) amortised
PopBack( ) as T                                 O(1)
PopFront( ) as T                                O(1)
TryPopBack( byref v as T ) as boolean           O(1)
TryPopFront( byref v as T ) as boolean          O(1)
Front( ) byref as T                             O(1)
Back( ) byref as T                              O(1)
operator [] ( byval i as long ) byref as T      O(1)   0 = front
At( byval i as long ) byref as T                O(1)
Count( ) as long                                O(1)
Capacity( ) as long                             O(1)   always a power of two
IsEmpty( ) as boolean                           O(1)
Clear( )                                        O(n)   keeps the capacity
Reserve( byval n as long )
GetIterator( ) as DequeIterator( of T )
```

## See Also

[Array](Category-Array) · [LinkedList](Category-LinkedList) · [PriorityQueue](Category-PriorityQueue)
