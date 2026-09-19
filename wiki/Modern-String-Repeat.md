[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Repeat**

# Repeat

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*count)

## Syntax

```freebasic
Repeat( count, s )
```

## Notes

- O(n*count)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Repeat( 3, "ab" )       '' ababab
print Repeat( 0, "ab" )       '' (empty) -- 0 or less gives ""

'' STRING( n, ch ) repeats one character; this repeats a whole string,
'' in one allocation rather than n concatenations
print Repeat( 20, "-" )       '' --------------------
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
