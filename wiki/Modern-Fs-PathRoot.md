[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathRoot**

# PathRoot

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

"C:\", "\\srv\share\", "/", "" -- see below

## Syntax

```freebasic
PathRoot( p )
```

## Notes

- "C:\", "\\srv\share\", "/", "" -- see below

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathRoot( "C:\dev\src" )            '' C:\
print PathRoot( "\\srv\share\dir" )      '' \\srv\share\
print PathRoot( "relative\path" )        '' (empty) -- no root at all

'' A UNC share is the root, not just the server: \\srv alone is not a
'' place you can be
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
