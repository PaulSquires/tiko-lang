[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **SpanOf**

# SpanOf

Counts the run of characters from a set that starts at a position.

## Syntax

```freebasic
SpanOf( start, s, chars [, ic] )
```

## Notes

- O(n*k) — long

## Examples

```freebasic
#import "std/strings"
using strings

print SpanOf( 1, "   x", " " )        '' 3 -- three leading spaces
print SpanOf( 1, "x", " " )           '' 0 -- stops immediately
print SpanOf( 4, "   xyz", "xyz" )    '' 3 -- counts from position 4 on

'' Skipping indentation without a trim
dim as ustring line_ = "    indented"
print mid( line_, SpanOf( 1, line_, " " ) + 1 )    '' indented
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
