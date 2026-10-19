[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Count**

# Count

Counts the elements in an array.

## Syntax

```freebasic
Count( byref a as Array( of T ) ) as uint64
```

## Notes

- Present so that a statistic and its sample size come from the same place.
- It is also a `RunningStats` member, where it counts what has been added so far.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Count( a )          '' 5

'' The same number the array itself reports
print a.Count( )          '' 5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
