[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextULong**

# NextULong

A uniformly random 32-bit value.

## Syntax

```freebasic
NextULong( ) as uint32
```

## Notes

- The top 32 bits of a 64-bit draw, so it costs the same as `NextULongInt`.
- Every one of the 2^32 values is equally likely.
- Like the rest of the Rng, not secure.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

dim as uint32 a = r.NextULong( )
dim as uint32 b = r.NextULong( )

print a <> b                 '' -1 (true), almost always
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
