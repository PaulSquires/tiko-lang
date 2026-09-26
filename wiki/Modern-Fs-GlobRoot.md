[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GlobRoot**

# GlobRoot

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the directory a pattern will be walked from

## Syntax

```freebasic
GlobRoot( pattern )
```

## Notes

- the directory a pattern will be walked from

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The directory a pattern will be walked FROM -- the fixed prefix
'' before the first wildcard
print GlobRoot( "C:\dev\src\*.tko" )     '' C:\dev\src
print GlobRoot( "C:\dev\**\*.tko" )      '' C:\dev

'' A pattern with no wildcard at all is its own parent
print GlobRoot( "C:\dev\main.tko" )       '' C:\dev

'' Pure: it parses the pattern and touches nothing
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
