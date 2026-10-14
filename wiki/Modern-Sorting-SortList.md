[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **SortList**

# SortList

O(n log n) worst   O(1) extra, STABLE

## Syntax

```freebasic
SortList( l )
```

## Notes

- O(n log n) worst — O(1) extra, STABLE

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of int32 )
q.PushBack( 5 ) : q.PushBack( 1 ) : q.PushBack( 4 )

SortList( q )                '' ascending, by T's own '<'
for each v in q
    print v;
next
print                        '' 1 4 5

'' There is ONE list sort and it is the stable one. Introsort needs
'' random access to reach its pivot and to scan inward from both ends,
'' and a linked list gives neither -- so this is a bottom-up merge sort
'' that RELINKS nodes rather than moving elements.
```

---

**Library:** [Sorting](Category-Sorting)  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures
