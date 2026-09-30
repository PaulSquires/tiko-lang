[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **ExceptWith**

# ExceptWith

Removes every element of `other` from this set.

## Syntax

```freebasic
ExceptWith( byref other as Set( of T ) )
```

## Notes

- Modifies the receiver. `other` is left untouched.
- The set difference: what is left is in this set and not in `other`.
- Removing `other`'s elements one at a time is O(|other|), which beats scanning this set when `other` is the smaller side.

## Examples

```freebasic
#import "std/containers"
using FB

dim a as Set( of integer )
dim b as Set( of integer )

for i as integer = 1 to 5 : a.Add( i ) : next     '' { 1, 2, 3, 4, 5 }
for i as integer = 4 to 9 : b.Add( i ) : next     '' { 4, 5, 6, 7, 8, 9 }

a.ExceptWith( b )
print a.Count            '' 3 -- { 1, 2, 3 }
print b.Count            '' 6 -- `other` is left alone

'' Elements of `other` that were never in the set are simply not there
'' to remove -- no error, no effect
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
