[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Escape**

# Escape

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Escape( s )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as ustring s = "path" & chr(9) & "c:\tmp" & chr(10)

print Escape( s )                  '' path\tc:\\tmp\n
print Escape( "say ""hi""" )       '' say \"hi\"

'' Non-ASCII passes through: the job is to neutralise what breaks
'' quoting, not to force the text to ASCII
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
