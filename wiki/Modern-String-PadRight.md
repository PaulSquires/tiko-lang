[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadRight**

# PadRight

O(width)

## Syntax

```freebasic
PadRight( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print PadRight( "FreeBasic", 12, "*" )    '' FreeBasic***
print PadRight( "FreeBasic", 12 )         '' FreeBasic    (spaces)

'' The result is ALWAYS exactly `width` -- longer input is truncated,
'' which is what makes a column line up whatever is in it
print PadRight( "FreeBasic", 4, "*" )     '' Free
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
