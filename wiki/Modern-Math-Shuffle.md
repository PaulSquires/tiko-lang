[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Shuffle**

# Shuffle

Shuffles an array in place so that every order is equally likely.

## Syntax

```freebasic
Shuffle( r, a( ) )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )
dim as int32 a( 0 to 4 ) = { 1, 2, 3, 4, 5 }

'' Fisher-Yates, in place and unbiased -- every permutation equally
'' likely, which the sort-by-random-key trick does not give
Shuffle( r, a( ) )

dim as int32 total = 0
for i as int32 = 0 to 4
    total += a( i )
next
print total                  '' 15 -- the same elements, reordered
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
