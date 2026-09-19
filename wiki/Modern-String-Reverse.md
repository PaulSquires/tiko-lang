[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Reverse**

# Reverse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Reverse( s )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Reverse( "abcdef" )     '' fedcba
print Reverse( "" )           '' (empty)

'' A ustring reverses by character, keeping surrogate pairs intact;
'' a STRING is bytes with no declared encoding, so it reverses bytes
dim as ustring u = "abc"
print Reverse( u )            '' cba
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
