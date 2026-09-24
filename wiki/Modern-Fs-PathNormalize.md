[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathNormalize**

# PathNormalize

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

duplicate separators and a trailing one

## Syntax

```freebasic
PathNormalize( p )
```

## Notes

- collapses '.', resolves '..' LEXICALLY, removes

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Collapses duplicate separators and drops a trailing one
print PathNormalize( "C:\\dev\\\\src\\" )      '' C:\dev\src

'' PURELY TEXTUAL: it resolves . and .. by string arithmetic and never
'' touches the disk, so it cannot know that a component is a symlink
print PathNormalize( "C:\dev\src\..\inc" )     '' C:\dev\inc

'' CanonicalPath is the one that asks the filesystem
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
