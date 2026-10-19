[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Unescape**

# Unescape

Turns backslash escapes back into the characters they stand for.

## Syntax

```freebasic
Unescape( s )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

print Unescape( "line\nnext" )      '' two lines
print Unescape( "\x41\x42" )       '' AB
print Unescape( "\q" )             '' q -- an unrecognised escape yields the character

'' The exact inverse of Escape, for every input
dim as ustring s = "a\b" & chr(9) & """q"""
if Unescape( Escape( s ) ) = s then print "round trip holds"
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
