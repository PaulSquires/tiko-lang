[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadCenter**

# PadCenter

Centres the string in a width, padding both sides.

## Syntax

```freebasic
PadCenter( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#import "std/strings"
using strings

print PadCenter( "tiko-lang", 13, "*" )    '' **tiko-lang**

'' The odd unit goes on the RIGHT: one character in a field of four
'' gets one pad before and two after
print PadCenter( "x", 4, "*" )             '' *x**
print PadCenter( " Title ", 21, "=" )      '' ======= Title =======
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
