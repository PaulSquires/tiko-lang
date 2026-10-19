[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Escape**

# Escape

Replaces quotes, backslashes and control characters with backslash escapes.

## Syntax

```freebasic
Escape( s )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring s = "path" & chr(9) & "c:\tmp" & chr(10)

print Escape( s )                  '' path\tc:\\tmp\n
print Escape( "say ""hi""" )       '' say \"hi\"

'' Non-ASCII passes through: the job is to neutralise what breaks
'' quoting, not to force the text to ASCII
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions
