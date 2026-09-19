[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **RemoveDir**

# RemoveDir

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FS_DIR_NOT_EMPTY on a populated directory

## Syntax

```freebasic
RemoveDir( p )
```

## Notes

- FS_DIR_NOT_EMPTY on a populated directory

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring sub_ = PathJoin( dir_, "one" )
CreateDir( sub_ )

print RemoveDir( sub_ ).IsOk( )          '' true
print Exists( sub_ )                     '' false

'' EMPTY DIRECTORIES ONLY -- a non-empty one fails rather than taking
'' its contents with it
CreateDir( sub_ )
WriteAllText( PathJoin( sub_, "f.txt" ), "x" )
print RemoveDir( sub_ ).IsOk( )          '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
