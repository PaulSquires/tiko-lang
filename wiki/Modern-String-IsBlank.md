[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **IsBlank**

# IsBlank

O(n)     boolean

## Syntax

```freebasic
IsBlank( s )
```

## Notes

- O(n) — boolean

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print IsBlank( "" )                    '' true
print IsBlank( "   " & chr(9) )        '' true -- space, tab, LF, VT, FF, CR
print IsBlank( " x " )                 '' false

'' Skipping empty configuration lines
dim as ustring line_ = "   "
if IsBlank( line_ ) then print "nothing to parse"
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
