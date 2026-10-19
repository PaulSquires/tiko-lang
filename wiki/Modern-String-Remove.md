[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Remove**

# Remove

Removes every occurrence of the text.

## Syntax

```freebasic
Remove( s, match [, ic] )
```

## Notes

- O(n*m)

## Examples

```freebasic
#import "std/strings"
using strings

print Remove( "Hello World", "l" )       '' Heo Word
print Remove( "a-b-c", "-" )             '' abc

'' Exactly Replace with an empty replacement, and single pass:
'' deleting "ab" from "aabb" leaves "ab", it does not cascade
print Remove( "aabb", "ab" )             '' ab
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
