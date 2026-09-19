[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Replace**

# Replace

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*m)

## Syntax

```freebasic
Replace( s, match, with_ [, ic] )
```

## Notes

- O(n*m)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Replace( "Hello World", "World", "Earth" )    '' Hello Earth
print Replace( "hello world", "WORLD", "Earth", true )    '' hello Earth

'' Single pass: a replacement containing the pattern never cascades
print Replace( "a", "a", "aa" )        '' aa, not a hang
print Replace( "abc", "", "-" )        '' abc -- an empty match copies through
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
