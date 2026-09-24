[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathIsRoot**

# PathIsRoot

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the whole path is exactly its root

## Syntax

```freebasic
PathIsRoot( p )
```

## Notes

- the whole path is exactly its root

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathIsRoot( "C:\" )                 '' true
print PathIsRoot( "C:\dev" )             '' false
print PathIsRoot( "\\srv\share\" )      '' true

'' True only when the WHOLE path is exactly its own root, which is the
'' terminating condition for a walk up through PathParent
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
