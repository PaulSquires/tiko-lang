[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MaxValue**

# MaxValue

Returns the largest value added so far.

## Syntax

```freebasic
RunningStats.MaxValue( ) as float64
```

## Notes

- Tracked incrementally, like `MinValue`.
- `MaxOf` is the array equivalent.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim rs as RunningStats
for i as int32 = 1 to 5 : rs.Add( i ) : next

print rs.MaxValue( )         '' 5
print rs.MaxValue( ) - rs.MinValue( )         '' 4
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
