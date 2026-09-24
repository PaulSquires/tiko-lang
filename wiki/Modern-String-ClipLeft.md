[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **ClipLeft**

# ClipLeft

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
ClipLeft( s, count )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print ClipLeft( "1234567890", 3 )     '' 4567890
print ClipLeft( "1234567890", 0 )     '' 1234567890 -- 0 or less removes nothing
print ClipLeft( "1234567890", 99 )    '' (empty) -- past the length removes everything

'' Dropping a known prefix
print ClipLeft( "--verbose", 2 )      '' verbose
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
