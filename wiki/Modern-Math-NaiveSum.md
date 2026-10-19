[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NaiveSum**

# NaiveSum

Adds up an array with a plain loop: faster than Sum, but small values can be lost.

## Syntax

```freebasic
NaiveSum( byref a as Array( of T ) ) as float64
```

## Notes

- the fast one, named so you meant it

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

'' The straight loop -- FASTER, and NAMED SO YOU MEANT IT
dim as Array( of float64 ) a = { 1e16, 1.0, -1e16, 1.0 }

print NaiveSum( a )       '' 1 -- one of the two 1.0s vanished into
                             '' the 1e16 and never came back
print Sum( a )            '' 2 -- compensated, so both survive

'' Use it when the values are of similar magnitude and the count is
'' small; use Sum when they are not, or when you do not know
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
