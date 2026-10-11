[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **LinkedNode**

# LinkedNode

## Syntax

```freebasic
LinkedNode( of T )
```

## Examples

```freebasic
#import "std/containers"
using containers

'' The node the list is built from: a value and two raw pointers.
'' Ordinary code never touches it -- Push*/Pop*/Front/Back and the
'' iterator are the interface -- but it is what makes the ownership
'' rules visible.
dim q as LinkedList( of int32 )
dim as int32 x = 42
q.PushBack( x )

'' The list holds RAW NODE POINTERS, unlike Array/Map/Set whose storage
'' is a dynamic array the language copies and frees for you. So the copy
'' constructor, `operator let` and destructor are all written out: a
'' default copy would share one chain between two lists and double-free.
dim copy_ as LinkedList( of int32 ) = q      '' deep copy, own chain
copy_.Front( ) = 99
print q.Front( ) & " " & copy_.Front( )     '' 42 99
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Implementation  
**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
