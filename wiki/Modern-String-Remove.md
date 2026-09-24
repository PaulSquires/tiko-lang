[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Remove**

# Remove

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*m)

## Syntax

```freebasic
Remove( s, match [, ic] )
```

## Notes

- O(n*m)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Remove( "Hello World", "l" )       '' Heo Word
print Remove( "a-b-c", "-" )             '' abc

'' Exactly Replace with an empty replacement, and single pass:
'' deleting "ab" from "aabb" leaves "ab", it does not cascade
print Remove( "aabb", "ab" )             '' ab
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
