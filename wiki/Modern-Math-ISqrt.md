[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ISqrt**

# ISqrt

exact floor of the true root

## Syntax

```freebasic
ISqrt( n )
```

## Notes

- exact floor of the true root

## Examples

```freebasic
#import "std/numeric"
using numeric

'' The EXACT floor of the true square root -- integer arithmetic
'' throughout, so it cannot be off by one the way clng( sqr( n ) ) can
dim as uint64 n = 26
print ISqrt( n )             '' 5

dim as uint64 sq = 25
print ISqrt( sq )            '' 5

'' At sizes where a double runs out of significand, sqr( ) starts
'' rounding to the wrong integer; this never does
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
