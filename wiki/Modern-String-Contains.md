[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Contains**

# Contains

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*m)   boolean

## Syntax

```freebasic
Contains( s, match [, ic] )
```

## Notes

- O(n*m) — boolean

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as string log_ = "WARN disk almost full"

print Contains( log_, "disk" )          '' true
print Contains( log_, "DISK" )          '' false
print Contains( log_, "DISK", true )    '' true

if Contains( log_, "WARN" ) then print "needs attention"
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
