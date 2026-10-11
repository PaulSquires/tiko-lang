[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextBooleanP**

# NextBooleanP

## Syntax

```freebasic
NextBooleanP( p )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

'' TRUE with probability p
print r.NextBooleanP( 1.0 )  '' true -- certain
print r.NextBooleanP( 0.0 )  '' false -- never

dim as int32 hits = 0
for i as int32 = 1 to 1000
    if r.NextBooleanP( 0.5 ) then hits += 1
next
print hits > 350 andalso hits < 650       '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
