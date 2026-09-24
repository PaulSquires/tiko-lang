[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathStartsWith**

# PathStartsWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
PathStartsWith( p, pre )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Whole-COMPONENT prefix test, not a string prefix -- which is what
'' makes it safe for a containment check
print PathStartsWith( "C:\dev\src", "C:\dev" )       '' true

'' "C:\development" does NOT start with "C:\dev", though the text does
print PathStartsWith( "C:\development", "C:\dev" )    '' false

'' The check to use before trusting a user-supplied path to stay inside
'' a directory -- after normalising it
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
