[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Shrink**

# Shrink

O(n*k)

## Syntax

```freebasic
Shrink( s [, mask] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#import "std/strings"
using FB

dim as ustring s = ",,, one , two     three, four,"

print Shrink( s, " ," )       '' one two three four
print Shrink( "  a   b  " )   '' a b -- the default mask is a space
print Shrink( s, "" )         '' unchanged -- an empty mask has nothing to shrink
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
