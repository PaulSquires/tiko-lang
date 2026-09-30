[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Unescape**

# Unescape

O(n)

## Syntax

```freebasic
Unescape( s )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

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
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
