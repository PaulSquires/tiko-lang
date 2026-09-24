[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateDirAll**

# CreateDirAll

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

mkdir -p; SUCCEEDS if it is already a directory

## Syntax

```freebasic
CreateDirAll( p )
```

## Notes

- mkdir -p; SUCCEEDS if it is already a directory

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' mkdir -p: creates every missing parent
dim as ustring deep = PathJoin( dir_, "a", "b", "c" )

print CreateDirAll( deep ).IsOk( )       '' true
print IsDir( deep )                      '' true

'' And it SUCCEEDS when the directory is already there, which is the
'' difference from CreateDir -- so it is the one to call when you want
'' the directory to exist rather than to have made it
print CreateDirAll( deep ).IsOk( )       '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
