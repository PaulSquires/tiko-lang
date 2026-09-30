[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextULongInt**

# NextULongInt

A uniformly random 64-bit value.

## Syntax

```freebasic
NextULongInt( ) as uint64
```

## Notes

- The **raw generator output**: every bit is random, and every one of the 2^64 values is equally likely.
- This is what the other Next* members are built from -- `NextDouble` takes 53 bits of it, `NextInt` rejects and retries to stay unbiased.
- Not secure. `CryptoULongInt` is the equivalent from the OS entropy source.

## Examples

```freebasic
#import "std/numeric"
using FB

dim r as Rng = RngFromEntropy( )

dim as uint64 a = r.NextULongInt( )
dim as uint64 b = r.NextULongInt( )

print a <> b                 '' -1 (true), with overwhelming probability

'' Do NOT reduce it with MOD to get a range -- that biases the low end.
'' NextInt rejects and retries instead.
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
