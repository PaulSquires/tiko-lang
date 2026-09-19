[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Between**

# Between

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*m)

## Syntax

```freebasic
Between( s, open, close [, start] [, ic] )
```

## Notes

- O(n*m)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Between( "blah (text here) blah", "(", ")" )   '' text here
print Between( "(a)(b)", "(", ")" )                  '' a -- pairs cannot cross
print Between( "blah (unclosed", "(", ")" )          '' (empty) -- both ends required

'' Wrap's inverse when you only want the inside
print Between( "<title>Report</title>", "<title>", "</title>" )    '' Report
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
