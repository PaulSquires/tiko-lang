[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadCenter**

# PadCenter

O(width)

## Syntax

```freebasic
PadCenter( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print PadCenter( "FreeBasic", 13, "*" )    '' **FreeBasic**

'' The odd unit goes on the RIGHT: one character in a field of four
'' gets one pad before and two after
print PadCenter( "x", 4, "*" )             '' *x**
print PadCenter( " Title ", 21, "=" )      '' ======= Title =======
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
