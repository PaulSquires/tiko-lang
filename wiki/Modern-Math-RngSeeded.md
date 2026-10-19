[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RngSeeded**

# RngSeeded

Creates a random generator from a seed, so the same seed repeats the same sequence.

## Syntax

```freebasic
RngSeeded( byval seed as uint64 ) as Rng
```

## Notes

- **Reproducible**: the same seed gives the same sequence on every run and every platform, which is what a test needs.
- `RngFromEntropy` is the other constructor, seeded from the OS and therefore different every run.
- Not cryptographically secure -- knowing a few outputs reveals the state. `CryptoBytes` is the one for keys and tokens.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as uint64 seed = 12345
dim a as Rng = RngSeeded( seed )
dim b as Rng = RngSeeded( seed )

'' The same seed gives the same sequence -- which is what makes a test
'' with random input reproducible
dim as int64 lo = 1, hi = 1000000
print a.NextInt( lo, hi ) = b.NextInt( lo, hi )      '' -1 (true)
print a.NextInt( lo, hi ) = b.NextInt( lo, hi )      '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
