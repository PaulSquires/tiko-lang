[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **SortList**

# SortList

ascending, by '<' on T

## Syntax

```freebasic
SortList( l )
```

## Notes

- ascending, by '<' on T

## Examples

```freebasic
#include once "fb/linkedlist.bi"
#include once "fb/sort.bi"
using FB

dim q as LinkedList( of long )
q.PushBack( 5 ) : q.PushBack( 1 ) : q.PushBack( 4 )

SortList( q )            '' ascending, by T's own '<'
for each v in q
    print v;
next
print                    '' 1 4 5

'' There is ONE list sort and it is the stable one: introsort needs
'' random access for its pivot and to scan inward from both ends, and a
'' linked list gives neither. So this is a bottom-up merge sort that
'' relinks nodes -- no elements are moved.
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Sorting  
**Source:** `docs/linkedlist/linkedlist.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
