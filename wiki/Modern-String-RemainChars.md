[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RemainChars**

# RemainChars

O(n*k)

## Syntax

```freebasic
RemainChars( s, chars [, start] [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print RemainChars( "width: 80", ":=" )       '' " 80" -- everything after the ":"
print RemainChars( "abacadabra", "cd" )      '' adabra -- after the first c or d
print RemainChars( "abacadabra", "xyz" )     '' (empty) -- a miss gives ""
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
