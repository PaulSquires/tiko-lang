[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Join**

# Join

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(total) text

## Syntax

```freebasic
Join( parts [, delim] )
```

## Notes

- O(total) text

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as Array( of string ) parts = Split( "a,b,c" )

print Join( parts )            '' a,b,c -- the default delimiter is a comma
print Join( parts, " | " )     '' a | b | c
print Join( parts, "" )        '' abc

'' Join( Split( s ) ) is s for every s
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
