[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **InstrChars**

# InstrChars

O(n*k)   long

## Syntax

```freebasic
InstrChars( start, s, chars [, ic] )
```

## Notes

- O(n*k) — long

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring s = "name = value"

print InstrChars( 1, s, "=:" )       '' 6 -- first of either delimiter
print InstrChars( 7, s, "=:" )       '' 0 -- none from position 7 on
print InstrChars( 1, s, "" )         '' 0 -- an empty set cannot match
print InstrChars( 0, s, "=:" )       '' 0 -- a start below 1 answers 0
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
