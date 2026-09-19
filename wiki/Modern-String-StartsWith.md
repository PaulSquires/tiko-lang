[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **StartsWith**

# StartsWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(m)     boolean

## Syntax

```freebasic
StartsWith( s, prefix [, ic] )
```

## Notes

- O(m) — boolean

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print StartsWith( "Hello", "He" )         '' true
print StartsWith( "Hello", "he" )         '' false -- case matters by default
print StartsWith( "Hello", "he", true )   '' true
print StartsWith( "Hello", "" )           '' true -- every string starts with ""
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
