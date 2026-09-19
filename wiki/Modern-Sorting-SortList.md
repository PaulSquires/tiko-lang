[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **SortList**

# SortList

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n log n) worst   O(1) extra, STABLE

## Syntax

```freebasic
SortList( l )
```

## Notes

- O(n log n) worst — O(1) extra, STABLE

## Examples

```freebasic
#include once "fb/linkedlist.bi"
#include once "fb/sort.bi"
using FB

dim q as LinkedList( of long )
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

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the tiko-lang repository.
