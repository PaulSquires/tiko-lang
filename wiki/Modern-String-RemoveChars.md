[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RemoveChars**

# RemoveChars

O(n*k)

## Syntax

```freebasic
RemoveChars( s, chars [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print RemoveChars( "abacadabra", "bac" )      '' dr
print RemoveChars( "(555) 123-4567", "() -" )    '' 5551234567
print RemoveChars( "abacadabra", "" )         '' abacadabra -- an empty set deletes nothing
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
