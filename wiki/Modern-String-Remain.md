[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Remain**

# Remain

Returns the text after a match, or an empty string if there is none.

## Syntax

```freebasic
Remain( s, match [, start] [, ic] )
Remain( s, missing )
```

## Notes

- O(n*m) — text after match
- ""

## Examples

```freebasic
#import "std/strings"
using strings

print Remain( "Brevity is the soul of wit", "is " )   '' the soul of wit
print Remain( "Brevity is the soul of wit", "zzz" )   '' (empty) -- a miss gives ""

'' Remain and Extract are complements: before, and after
dim as ustring s = "key=value"
print Extract( 1, s, "=" ) & " -> " & Remain( s, "=" )   '' key -> value
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
