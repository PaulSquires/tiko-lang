[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **LinkCount**

# LinkCount

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultULong

## Syntax

```freebasic
LinkCount( p )
```

## Notes

- FsResultULong

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' How many hard links -- names -- this file has. One for an ordinary
'' file.
dim r as FsResultULong = LinkCount( p )

print r.IsOk( )              '' true
print r.Value( )             '' 1

'' A count above 1 means deleting this name does NOT free the data, and
'' that writing through one name changes what the others see

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
