[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Merge**

# Merge

Folds another accumulator's data into this one.

## Syntax

```freebasic
RunningStats.Merge( byref other as RunningStats )
```

## Notes

- What makes `RunningStats` **parallelisable**: each worker accumulates its own, and the results merge at the end into exactly the statistics one pass would have produced.
- Merging is exact, not an approximation -- the combined mean and variance are computed from both counts and both means.
- Merging an empty accumulator changes nothing.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim a as RunningStats
dim b as RunningStats

for i as int32 = 1 to 3 : a.Add( i ) : next
for i as int32 = 4 to 6 : b.Add( i ) : next

a.Merge( b )
print a.Count( )             '' 6
print a.Mean( )              '' 3.5

'' Exactly what one pass over 1..6 would have given
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
