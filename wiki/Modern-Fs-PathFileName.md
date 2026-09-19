[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathFileName**

# PathFileName

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the leaf; "" for a root

## Syntax

```freebasic
PathFileName( p )
```

## Notes

- the leaf; "" for a root

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathFileName( "C:\dev\src\main.bas" )       '' main.bas
print PathFileName( "main.bas" )                  '' main.bas

'' Empty for a root: there is no leaf there
print "[" & PathFileName( "C:\" ) & "]"           '' []
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
