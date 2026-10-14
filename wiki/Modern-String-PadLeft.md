[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadLeft**

# PadLeft

O(width)

## Syntax

```freebasic
PadLeft( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#import "std/strings"
using strings

print PadLeft( "tiko-lang", 12, "*" )    '' ***tiko-lang
print PadLeft( "42", 5, "0" )            '' 00042
print PadLeft( "tiko-lang", 4, "*" )     '' tiko -- truncated, keeping the left
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
