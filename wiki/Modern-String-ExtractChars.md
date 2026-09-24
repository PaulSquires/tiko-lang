[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **ExtractChars**

# ExtractChars

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*k)

## Syntax

```freebasic
ExtractChars( start, s, chars [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print ExtractChars( 1, "abacadabra", "cd" )     '' aba -- stops at the first c or d
print ExtractChars( 1, "abacadabra", "xyz" )    '' abacadabra -- a miss keeps the remainder

'' Reading a key up to whichever delimiter comes first
print ExtractChars( 1, "width: 80", ":= " )     '' width
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
