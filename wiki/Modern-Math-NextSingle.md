[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextSingle**

# NextSingle

A single in [0, 1).

## Syntax

```freebasic
NextSingle( ) as float32
```

## Notes

- The single-precision counterpart of `NextDouble`, with 24 bits of randomness rather than 53.
- Half-open, on the same rule.
- Use it when the value feeds single-precision arithmetic anyway; there is no accuracy to gain from the wider draw.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

dim as float32 v = r.NextSingle( )
print v >= 0.0 andalso v < 1.0                '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
