[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.GetIterator**

# OrderedSet.GetIterator

O(log n)

## Syntax

```freebasic
GetIterator( )
```

## Notes

- O(log n)

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

'' ASCENDING ORDER, always
for each v in s
    print v;
next
print                    '' 10 20 30

dim it as OrderedSetIterator( of integer ) = s.GetIterator( )
print it.Value( )        '' 10 -- the smallest element
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
