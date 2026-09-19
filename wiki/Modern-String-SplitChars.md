[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **SplitChars**

# SplitChars

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*k)   Array( of T )

## Syntax

```freebasic
SplitChars( s [, chars] [, ic] )
```

## Notes

- O(n*k) — Array( of T )

## Examples

```freebasic
#include once "fb/string.bi"
using FB

'' Split on a SET of characters rather than one delimiter string
dim as Array( of string ) parts = SplitChars( "a,b;c", ",;" )

print parts.Count        '' 3
print parts[ 1 ]         '' b

'' Every delimiter counts, so runs produce empty fields
print SplitChars( "a,,b", "," ).Count    '' 3
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
