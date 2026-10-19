[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Reverse**

# Reverse

Returns the string with its characters in reverse order.

## Syntax

```freebasic
Reverse( s )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

print Reverse( "abcdef" )     '' fedcba
print Reverse( "" )           '' (empty)

'' A ustring reverses by character, keeping surrogate pairs intact;
'' a STRING is bytes with no declared encoding, so it reverses bytes
dim as ustring u = "abc"
print Reverse( u )            '' cba
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
