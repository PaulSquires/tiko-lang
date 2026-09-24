[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadLeft**

# PadLeft

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(width)

## Syntax

```freebasic
PadLeft( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print PadLeft( "FreeBasic", 12, "*" )    '' ***FreeBasic
print PadLeft( "42", 5, "0" )            '' 00042
print PadLeft( "FreeBasic", 4, "*" )     '' Free -- truncated, keeping the left
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
