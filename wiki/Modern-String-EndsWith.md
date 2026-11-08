[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **EndsWith**

# EndsWith

Returns true if the string ends with the given text.

## Syntax

```freebasic
EndsWith( s, suffix [, ic] )
```

## Notes

- Overloads for [slices](Category-String-Slices) take `const` `slice`, `uslice` or `wslice` arguments and copy nothing: `EndsWith( v[0 to 9], "x" )`. A string argument still gets the string overload.
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
