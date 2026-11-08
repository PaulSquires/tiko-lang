[Home](Home) › [String Library](Category-String-Library) › [String Slices](Category-String-Slices) › **TrimSpace**

# TrimSpace

Returns a slice of the text without the spaces, tabs, CRs and LFs at either end.

## Syntax

```freebasic
TrimSpace( v )
```

## Notes

- The result is a `const` slice **of the argument**, not a copy, so it lives as long as the argument does. Keep it in a `ustring` to keep the text: `dim as ustring t = TrimSpace( s )`.
- Only space, tab, carriage return and line feed are trimmed. `Trim` trims spaces, or a given set of characters, and returns a copy.
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
