[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **PadCenter**

# PadCenter

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(width)

## Syntax

```freebasic
PadCenter( s, width [, pad] )
```

## Notes

- O(width)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print PadCenter( "FreeBasic", 13, "*" )    '' **FreeBasic**

'' The odd unit goes on the RIGHT: one character in a field of four
'' gets one pad before and two after
print PadCenter( "x", 4, "*" )             '' *x**
print PadCenter( " Title ", 21, "=" )      '' ======= Title =======
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
