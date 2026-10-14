[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Reset**

# Reset

Empties a running accumulator so it can be reused.

## Syntax

```freebasic
RunningStats.Reset( )
```

## Notes

- Cheap: it clears a handful of scalars rather than freeing anything.
- The point is to reuse one accumulator across many batches without reconstructing it in a loop.
- After it, `Count` is 0 and the statistics read as they do on a fresh one.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim rs as RunningStats
for i as int32 = 1 to 5 : rs.Add( i ) : next
print rs.Count( )            '' 5

rs.Reset( )
print rs.Count( )            '' 0

'' Ready for the next batch, with nothing reallocated
rs.Add( 42 )
print rs.Mean( )             '' 42
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
