[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadRight**

# PadRight

Pads on the right to a width, with spaces or a given character.

## Syntax

```freebasic
PadRight( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#import "std/strings"
using strings

print PadRight( "tiko-lang", 12, "*" )    '' tiko-lang***
print PadRight( "tiko-lang", 12 )         '' tiko-lang    (spaces)

'' The result is ALWAYS exactly `width` -- longer input is truncated,
'' which is what makes a column line up whatever is in it
print PadRight( "tiko-lang", 4, "*" )     '' tiko
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
