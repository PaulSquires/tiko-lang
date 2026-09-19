[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathSeparator**

# PathSeparator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

"\" or "/"

## Syntax

```freebasic
PathSeparator( )
```

## Notes

- "\" or "/"

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The native separator, as a string
print PathSeparator( )       '' \ on Windows, / elsewhere

'' Or ask for a grammar explicitly -- every Path* function takes the
'' same optional final argument
print PathSeparator( FB_PATH_POSIX )     '' /
print PathSeparator( FB_PATH_WIN32 )     '' \
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
