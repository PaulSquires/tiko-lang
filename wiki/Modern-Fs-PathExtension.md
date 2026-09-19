[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathExtension**

# PathExtension

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

".bas", WITH the dot; "" when there is none

## Syntax

```freebasic
PathExtension( p )
```

## Notes

- ".bas", WITH the dot; "" when there is none

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' WITH the dot, which is what makes it concatenate back on cleanly
print PathExtension( "main.bas" )         '' .bas
print PathExtension( "archive.tar.gz" )   '' .gz -- the last one

'' Empty when there is none, and a leading dot is a name, not an
'' extension
print "[" & PathExtension( "README" ) & "]"        '' []
print "[" & PathExtension( ".gitignore" ) & "]"    '' []
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
