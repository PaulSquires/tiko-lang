[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **IsBlank**

# IsBlank

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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
dim as string line_ = "   "
if IsBlank( line_ ) then print "nothing to parse"
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
