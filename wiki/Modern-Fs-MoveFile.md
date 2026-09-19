[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MoveFile**

# MoveFile

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MoveFile( src, dst [, overwrite ] )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring a = PathJoin( dir_, "a.txt" )
dim as ustring b = PathJoin( dir_, "b.txt" )
WriteAllText( a, "hello" )

print MoveFile( a, b ).IsOk( )           '' true
print Exists( a )                        '' false -- the source is gone
print ReadAllText( b ).Value( )          '' hello

'' Overwrite defaults FALSE here too
WriteAllText( a, "second" )
print MoveFile( a, b ).IsOk( )           '' false
print MoveFile( a, b, true ).IsOk( )     '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
