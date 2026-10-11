[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **EndsWith**

# EndsWith

O(m)     boolean

## Syntax

```freebasic
EndsWith( s, suffix [, ic] )
```

## Notes

- O(m) — boolean

## Examples

```freebasic
#import "std/strings"
using strings

print EndsWith( "report.txt", ".txt" )         '' true
print EndsWith( "report.TXT", ".txt", true )   '' true
print EndsWith( "report.txt", ".md" )          '' false
print EndsWith( "", "" )                       '' true -- vacuously
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
