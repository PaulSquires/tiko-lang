[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RemainChars**

# RemainChars

Returns the text after the first character from a set.

## Syntax

```freebasic
RemainChars( s, chars [, start] [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#import "std/strings"
using strings

print RemainChars( "width: 80", ":=" )       '' " 80" -- everything after the ":"
print RemainChars( "abacadabra", "cd" )      '' adabra -- after the first c or d
print RemainChars( "abacadabra", "xyz" )     '' (empty) -- a miss gives ""
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
