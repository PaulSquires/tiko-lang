[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **ExtractChars**

# ExtractChars

O(n*k)

## Syntax

```freebasic
ExtractChars( start, s, chars [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#import "std/strings"
using strings

print ExtractChars( 1, "abacadabra", "cd" )     '' aba -- stops at the first c or d
print ExtractChars( 1, "abacadabra", "xyz" )    '' abacadabra -- a miss keeps the remainder

'' Reading a key up to whichever delimiter comes first
print ExtractChars( 1, "width: 80", ":= " )     '' width
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
