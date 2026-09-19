[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **ReplaceChars**

# ReplaceChars

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

[, all] [, start] [, ic] )    O(n*m)

## Syntax

```freebasic
ReplaceChars( s, chars, with_ [, ic] )
```

## Notes

- O(n*k) — length is invariant

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print ReplaceChars( "abacadabra", "bac", "*" )    '' *****d**r*
print ReplaceChars( "a/b\c", "/\", "." )         '' a.b.c

'' The length never changes, so `with_` must be exactly one unit --
'' anything else returns the string unchanged rather than guessing
print ReplaceChars( "abc", "b", "xy" )            '' abc
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
