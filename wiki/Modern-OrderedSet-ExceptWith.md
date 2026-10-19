[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.ExceptWith**

# OrderedSet.ExceptWith

Removes every value that is also in another set.

## Syntax

```freebasic
ExceptWith( other )
```

## Notes

- O(m log n)

## Examples

```freebasic
#import "std/containers"
using containers

dim a as OrderedSet( of integer )
dim b as OrderedSet( of integer )

for i as integer = 1 to 5 : a.Add( i ) : next
for i as integer = 4 to 9 : b.Add( i ) : next

a.ExceptWith( b )        '' set difference, in place
print a.Count            '' 3
for each v in a
    print v;
next
print                    '' 1 2 3
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
