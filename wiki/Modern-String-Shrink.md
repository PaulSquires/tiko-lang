[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Shrink**

# Shrink

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*k)

## Syntax

```freebasic
Shrink( s [, mask] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as string s = ",,, one , two     three, four,"

print Shrink( s, " ," )       '' one two three four
print Shrink( "  a   b  " )   '' a b -- the default mask is a space
print Shrink( s, "" )         '' unchanged -- an empty mask has nothing to shrink
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
