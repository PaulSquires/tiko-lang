[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RngFromEntropy**

# RngFromEntropy

## Syntax

```freebasic
RngFromEntropy( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' A generator seeded from the OS entropy source, so two runs differ.
'' Rng( seed ) is the reproducible alternative.
dim r as Rng = RngFromEntropy( )

dim as int64 lo = 1, hi = 6
dim as int64 roll = r.NextInt( lo, hi )
print roll >= 1 andalso roll <= 6         '' -1 (true)

'' Seed it explicitly when a test has to be reproducible
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
