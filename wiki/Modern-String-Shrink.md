[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Shrink**

# Shrink

Trims both ends and collapses each inner run of spaces to one.

## Syntax

```freebasic
Shrink( s [, mask] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring s = ",,, one , two     three, four,"

print Shrink( s, " ," )       '' one two three four
print Shrink( "  a   b  " )   '' a b -- the default mask is a space
print Shrink( s, "" )         '' unchanged -- an empty mask has nothing to shrink
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
