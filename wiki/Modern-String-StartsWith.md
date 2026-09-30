[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **StartsWith**

# StartsWith

O(m)     boolean

## Syntax

```freebasic
StartsWith( s, prefix [, ic] )
```

## Notes

- O(m) — boolean

## Examples

```freebasic
#import "std/strings"
using FB

print StartsWith( "Hello", "He" )         '' true
print StartsWith( "Hello", "he" )         '' false -- case matters by default
print StartsWith( "Hello", "he", true )   '' true
print StartsWith( "Hello", "" )           '' true -- every string starts with ""
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
