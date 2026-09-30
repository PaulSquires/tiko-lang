[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NaiveSum**

# NaiveSum

the fast one, named so you meant it

## Syntax

```freebasic
NaiveSum( a( ) )
```

## Notes

- the fast one, named so you meant it

## Examples

```freebasic
#import "std/numeric"
using FB

'' The straight loop -- FASTER, and NAMED SO YOU MEANT IT
dim as float64 a( 0 to 3 ) = { 1e16, 1.0, -1e16, 1.0 }

print NaiveSum( a( ) )       '' 1 -- one of the two 1.0s vanished into
                             '' the 1e16 and never came back
print Sum( a( ) )            '' 2 -- compensated, so both survive

'' Use it when the values are of similar magnitude and the count is
'' small; use Sum when they are not, or when you do not know
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
