[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Median**

# Median

Returns the middle value of an array, without reordering it.

## Syntax

```freebasic
Median( byref a as Array( of T ) ) as float64
```

## Notes

- **Resistant to outliers** in a way the mean is not: one absurd value moves the mean and leaves the median where it was.
- An even count averages the two middle values, so the result need not be an element of the array.
- It sorts a copy; the input array is left alone.

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

dim as Array( of float64 ) a = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Median( a )         '' 4

'' One absurd value moves the mean and leaves the median alone
dim as Array( of float64 ) b = { 2.0, 4.0, 4.0, 4.0, 1e9 }
print Median( b )         '' 4
print Mean( b ) > 1e8     '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
