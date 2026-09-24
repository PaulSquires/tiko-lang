[Home](Home) › [All Categories](Categories) › **LinkedList**

# LinkedList

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
#include once "fb/linkedlist.bi"     ' or "containers.bi" for all four
using FB

dim q as LinkedList( of string )

q.PushBack( "b" )
q.PushFront( "a" )

print q.PopFront( )                  ' "a"

for each s in q
    print s
next
```

## When To Use It

It is the least important of the four containers, and it is here so that the answer to "what if I need a queue" is not "write your own".

Prefer Array unless one of these is what you actually need:

- O(1) insertion at the FRONT.  Array.Insert( 0, v ) is O(n). - An iterator that STAYS VALID across insertions elsewhere in the list.

```freebasic
Every Array iterator is invalidated by a Push that reallocates.
```

Array is faster for everything else -- contiguous storage, no per-element allocation, and no pointer chasing.

## Members

```freebasic
Count( ) as long                                O(1)
IsEmpty( ) as boolean                           O(1)

PushFront( byref v as T )                       O(1)
PushBack( byref v as T )                        O(1)
PopFront( ) as T                                O(1)  removes and returns
PopBack( ) as T                                 O(1)  removes and returns
Front( ) byref as T                             O(1)
Back( ) byref as T                              O(1)

Clear( )                                        O(n)
GetIterator( ) as LinkedListIterator( of T )    O(1)
```

As a queue (FIFO):

```freebasic
q.PushBack( item )
dim next_ as T = q.PopFront( )
```

As a stack (LIFO):

```freebasic
q.PushBack( item )
dim top as T = q.PopBack( )
```

## The Empty List

PopFront( ), PopBack( ), Front( ) and Back( ) on an empty list return a DEFAULT-CONSTRUCTED T. There is no error channel here and no exception to throw. Check IsEmpty( ) first if the difference matters:

```freebasic
while q.IsEmpty( ) = false
    process( q.PopFront( ) )
wend
```

Front( ) and Back( ) on an empty list return a reference to a shared blank -- a reference has to refer to something, and there is nothing else to refer to. Do not write through it.

## Ownership AND Copying -- The Part That Matters

Unlike Array, Map and Set -- whose storage is a dynamic array field, so the language deep-copies and destroys it for free -- this holds RAW NODE POINTERS.

The compiler-supplied copy would duplicate the head and tail pointers and give two lists sharing one chain, which then double-frees. So the destructor, the copy constructor and 'operator let' are all written out by hand, and they are the reason this container's source is longer than it looks.

COPY AND ASSIGNMENT ARE DEEP:

```freebasic
dim b as LinkedList( of long ) = a       ' every node duplicated
b.PushBack( 99 )                         ' a is unchanged

c = a                                    ' old contents freed, then copied
c = c                                    ' self-assignment is safe
```

Self-assignment is guarded explicitly: without the check, 'operator let' would free the chain and then walk it.

A LinkedList( of T ptr ) frees the NODES, not the pointees.

## Iterator Invalidation

This is the container's other reason to exist. Nothing detects a violation.

```freebasic
PushFront / PushBack                        iterators stay VALID
removing the node an iterator is on         that iterator invalidated
Clear                                       all iterators invalidated
```

Compare with Array, where any Push that reallocates invalidates everything.

## Implementation

Doubly linked, with the value stored by copy in each node. 'new' and 'delete' on a generic instantiation, including a self-referential

```freebasic
as LinkedNode( of T ) ptr nxt, prv
```

field, are what make this possible.

PushFront and PushBack copy the value BEFORE allocating the node, so

```freebasic
q.PushFront( q.Back( ) )
```

means what it looks like: the argument refers into a list that is about to be restructured.

## Sorting

```freebasic
#include once "fb/sort.bi"

SortList( l )               ascending, by '<' on T
SortListBy( l, less )       ascending, by a comparer
```

A bottom-up merge sort over the node chain: O(n log n) worst case, O(1) extra memory, STABLE, and NO ELEMENT IS MOVED AT ALL -- the nodes are relinked, so sorting a LinkedList( of string ) touches no string. Copying the list into an Array, sorting that and copying it back is slower, not faster.

There is one list sort and it is the stable one. Introsort is not available here and the reason is structural: quicksort needs random access to reach its pivot and to scan inward from both ends, and a linked list gives neither.

See docs/sort/sort.txt.

Source: src/inc/fb/linkedlist.bi

## Tests

src/tests/generics/container-linkedlist.bas is exhaustive: every member, empty / one / many states, both ends, the single-element case where head and tail are the same node (and removing it must clear both, or the next push links onto a freed node), FIFO and LIFO drains, draining from alternating ends, pushing the list's own element, 10k nodes checked end to end in order, FOR EACH in both binding forms with exit/continue, element types including strings and a nested container, and destructor balance with a counting element type.

The copy and assignment section is load-bearing rather than a formality: it checks independence in BOTH directions after copy construction and after assignment, self-assignment, assigning an empty list over a full one, and copying an empty list.

## API reference

One page per entry, 13 in all:

[Back](Modern-LinkedList-Back) · [Clear](Modern-LinkedList-Clear) · [Count](Modern-LinkedList-Count) · [Front](Modern-LinkedList-Front) · [GetIterator](Modern-LinkedList-GetIterator) · [IsEmpty](Modern-LinkedList-IsEmpty) · [LinkedList](Modern-LinkedList-LinkedList) · [LinkedListIterator](Modern-LinkedList-LinkedListIterator) · [LinkedNode](Modern-LinkedList-LinkedNode) · [PopBack](Modern-LinkedList-PopBack) · [PopFront](Modern-LinkedList-PopFront) · [PushBack](Modern-LinkedList-PushBack) · [PushFront](Modern-LinkedList-PushFront) · [SortList](Modern-LinkedList-SortList) · [SortListBy](Modern-LinkedList-SortListBy)

---

**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
