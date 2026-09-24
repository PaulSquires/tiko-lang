[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReplaceFile**

# ReplaceFile

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
ReplaceFile( target, replacement )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring target = PathJoin( dir_, "live.txt" )
dim as ustring newer = PathJoin( dir_, "staged.txt" )
WriteAllText( target, "old" )
WriteAllText( newer, "new" )

'' Replaces the target with the replacement AS ONE OPERATION, so a
'' reader never sees the target missing -- which a remove-then-rename
'' pair cannot promise
print ReplaceFile( target, newer ).IsOk( )       '' true
print ReadAllText( target ).Value( )             '' new
print Exists( newer )                            '' false

'' Both paths must be on the same volume

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
