[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CInfinity**

# CInfinity

Returns a complex number whose two parts are both positive infinity.

## Syntax

```freebasic
CInfinity( ) as Complex
```

## Notes

- A function rather than a constant — see `CNaN`.
- `CIsInfinite` is true for *any* complex number with an infinite component, not only for this one.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CIsInfinite( CInfinity( ) )              '' true
print CIsInfinite( CSet( 1.0, Infinity( ) ) )  '' true   -- one part is enough
print CAbs( CInfinity( ) )                     '' 1.#INF
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
