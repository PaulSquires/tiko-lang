[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **InstrChars**

# InstrChars

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*k)   long

## Syntax

```freebasic
InstrChars( start, s, chars [, ic] )
```

## Notes

- O(n*k) — long

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as string s = "name = value"

print InstrChars( 1, s, "=:" )       '' 6 -- first of either delimiter
print InstrChars( 7, s, "=:" )       '' 0 -- none from position 7 on
print InstrChars( 1, s, "" )         '' 0 -- an empty set cannot match
print InstrChars( 0, s, "=:" )       '' 0 -- a start below 1 answers 0
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
