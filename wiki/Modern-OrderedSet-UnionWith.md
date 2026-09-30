[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.UnionWith**

# OrderedSet.UnionWith

O(m log n)

## Syntax

```freebasic
UnionWith( other )
```

## Notes

- O(m log n)

## Examples

```freebasic
#import "std/containers"
using FB

dim a as OrderedSet( of integer )
dim b as OrderedSet( of integer )

for i as integer = 1 to 3 : a.Add( i ) : next
for i as integer = 3 to 5 : b.Add( i ) : next

a.UnionWith( b )         '' in place; `other` is left alone
print a.Count            '' 5 -- 3 was not duplicated
for each v in a
    print v;
next
print                    '' 1 2 3 4 5 -- still in order
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
