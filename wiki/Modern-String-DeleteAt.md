[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **DeleteAt**

# DeleteAt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
DeleteAt( s, start, count )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print DeleteAt( "1234567890", 4, 3 )    '' 1237890
print DeleteAt( "1234567890", 4, 99 )   '' 123 -- a count past the end takes what is there

'' Every invalid argument is a no-op, never a truncation
print DeleteAt( "1234567890", 0, 3 )    '' 1234567890 -- start below 1
print DeleteAt( "1234567890", 99, 3 )   '' 1234567890 -- start past the end
print DeleteAt( "1234567890", 4, 0 )    '' 1234567890 -- nothing to remove
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
