[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IPow**

# IPow

EXACT -- IPow( 3LL, 38LL ) = 1350851717672992089

## Syntax

```freebasic
IPow( base, exp )
```

## Notes

- EXACT -- IPow( 3LL, 38LL ) = 1350851717672992089

## Examples

```freebasic
#import "std/numeric"
using numeric

'' INTEGER power by squaring -- exact, with no trip through double
dim as int64 b = 2, e = 10
print IPow( b, e )           '' 1024

'' `2 ^ 10` goes through floating point and comes back as a double, so
'' it is exact only while the result fits in 53 bits. This is exact to
'' the full integer width.
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
