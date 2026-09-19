[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RetainChars**

# RetainChars

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*k)

## Syntax

```freebasic
RetainChars( s, chars [, ic] )
```

## Notes

- O(n*k)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print RetainChars( "abacadabra", "bc" )        '' bcb
print RetainChars( "(555) 123-4567", "0123456789" )    '' 5551234567
print RetainChars( "abacadabra", "" )          '' (empty) -- the complement of RemoveChars
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
