[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Open**

# MemoryMappedFile.Open

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultBool

## Syntax

```freebasic
MemoryMappedFile.Open( p [, writable ] )
```

## Notes

- FsResultBool

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim mm as MemoryMappedFile

'' Read-only by default; pass TRUE for a writable mapping
print mm.Open( p ).IsOk( )   '' true
print mm.IsOpen( )           '' true
print mm.Size( )             '' 5

mm.Close( )

'' AN EMPTY FILE CANNOT BE MAPPED -- there is no region to map, and both
'' platforms refuse it
dim as ustring empty_ = PathJoin( dir_, "empty.txt" )
WriteAllText( empty_, "" )
print mm.Open( empty_ ).IsOk( )           '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
