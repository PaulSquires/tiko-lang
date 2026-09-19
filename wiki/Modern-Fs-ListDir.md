[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ListDir**

# ListDir

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

eager; fills an Array( of DirEntry )

## Syntax

```freebasic
ListDir( p, entries )
```

## Notes

- eager; fills an Array( of DirEntry )

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
WriteAllText( PathJoin( dir_, "a.txt" ), "aaa" )
WriteAllText( PathJoin( dir_, "b.txt" ), "bb" )
CreateDir( PathJoin( dir_, "sub" ) )
WriteAllText( PathJoin( dir_, "sub", "c.txt" ), "c" )

'' EAGER: fills an Array and returns the count, for when the whole
'' listing is wanted at once and can be sorted or counted
dim entries as Array( of DirEntry )
dim r as FsResultLong = ListDir( dir_, entries )

print r.IsOk( )              '' true
print r.Value( )             '' 3
print entries.Count          '' 3

'' ReadDir is the lazy one; this is the convenient one

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
