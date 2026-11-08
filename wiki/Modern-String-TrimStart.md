[Home](Home) › [String Library](Category-String-Library) › [String Slices](Category-String-Slices) › **TrimStart**

# TrimStart

Returns a slice of the text without its leading spaces, tabs, CRs and LFs.

## Syntax

```freebasic
TrimStart( v )
```

## Notes

- The result is a `const` slice **of the argument**, not a copy, so it lives as long as the argument does. A slice of a temporary — a literal, a concatenation — can be printed or passed on in the same statement, not kept.
- Only space, tab, carriage return and line feed are trimmed.
- O(n) — const slice

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring s = !"  \t padded \r\n"
print "["; TrimStart( s ); "]"       '' [padded <CR><LF>]
print "["; TrimEnd( s ); "]"         '' [  <TAB> padded]
print "["; TrimSpace( s ); "]"       '' [padded]
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Slices](Category-String-Slices)  
**Documented under:** The Functions
