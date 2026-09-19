[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathJoin**

# PathJoin

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

also 3- and 4-argument forms

## Syntax

```freebasic
PathJoin( a, b )
```

## Notes

- also 3- and 4-argument forms

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathJoin( "C:\dev", "src" )         '' C:\dev\src

'' A separator is inserted only where one is needed, so joining does not
'' double it
print PathJoin( "C:\dev\", "src" )       '' C:\dev\src

'' Three- and four-argument forms exist, so a nested path needs one call
print PathJoin( "C:\dev", "src", "inc" )              '' C:\dev\src\inc
print PathJoin( "C:\dev", "src", "inc", "fb" )        '' C:\dev\src\inc\fb

'' An ABSOLUTE second argument replaces rather than appends
print PathJoin( "C:\dev", "D:\other" )   '' D:\other
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
