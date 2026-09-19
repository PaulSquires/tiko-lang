[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **EndsWith**

# EndsWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(m)     boolean

## Syntax

```freebasic
EndsWith( s, suffix [, ic] )
```

## Notes

- O(m) — boolean

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print EndsWith( "report.txt", ".txt" )         '' true
print EndsWith( "report.TXT", ".txt", true )   '' true
print EndsWith( "report.txt", ".md" )          '' false
print EndsWith( "", "" )                       '' true -- vacuously
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
