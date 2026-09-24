[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathRelativeTo**

# PathRelativeTo

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultUStr

## Syntax

```freebasic
PathRelativeTo( p, base )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' THE ONE PATH FUNCTION THAT CAN FAIL, so it returns an FsResult rather
'' than a bare string: there IS no relative path between two different
'' roots, and "..\..\D:\b" would be a fabrication.
dim r as FsResultUStr = PathRelativeTo( "C:\dev\src\main.bas", "C:\dev" )

if r.IsOk( ) then print r.Value( )       '' src\main.bas

'' It walks UP with .. when it has to
dim up as FsResultUStr = PathRelativeTo( "C:\dev\inc", "C:\dev\src" )
if up.IsOk( ) then print up.Value( )     '' ..\inc

'' Different drives have no relative path between them
dim bad as FsResultUStr = PathRelativeTo( "C:\a", "D:\b" )
print bad.IsOk( )                        '' false
print bad.Failure( ).Code( ) = FS_INVALID_PATH       '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
