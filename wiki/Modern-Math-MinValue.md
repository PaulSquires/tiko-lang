[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinValue**

# MinValue

Returns the smallest value added so far.

## Syntax

```freebasic
RunningStats.MinValue( ) as float64
```

## Notes

- Tracked as values arrive, so it costs one comparison per `Add` rather than a second pass.
- `MinOf` is the array equivalent.
- On an empty accumulator it reads as 0.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim rs as RunningStats
for i as int32 = 1 to 5 : rs.Add( i ) : next

print rs.MinValue( )         '' 1
print rs.MaxValue( )         '' 5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
