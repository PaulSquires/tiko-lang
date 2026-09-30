[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RetainChars**

# RetainChars

O(n*k)

## Syntax

```freebasic
RetainChars( s, chars [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#import "std/strings"
using FB

print RetainChars( "abacadabra", "bc" )        '' bcb
print RetainChars( "(555) 123-4567", "0123456789" )    '' 5551234567
print RetainChars( "abacadabra", "" )          '' (empty) -- the complement of RemoveChars
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
