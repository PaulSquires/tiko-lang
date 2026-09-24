[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Unwrap**

# Unwrap

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Unwrap( s [, open] [, close] [, ic] )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Unwrap( "<Paul>", "<", ">" )    '' Paul
print Unwrap( "<Paul", "<", ">" )     '' <Paul -- unbalanced, left untouched
print Unwrap( "''x''", "'" )          '' 'x' -- ONE pair removed, not all
print Unwrap( """quoted""" )          '' quoted -- the default pair
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
