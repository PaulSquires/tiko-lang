[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathStem**

# PathStem

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the leaf without its extension

## Syntax

```freebasic
PathStem( p )
```

## Notes

- the leaf without its extension

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The leaf without its extension
print PathStem( "C:\dev\main.tko" )      '' main
print PathStem( "archive.tar.gz" )        '' archive.tar -- the LAST dot only

'' A dotfile with no extension keeps its whole name
print PathStem( ".gitignore" )            '' .gitignore
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
