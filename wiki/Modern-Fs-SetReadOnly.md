[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetReadOnly**

# SetReadOnly

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

portable

## Syntax

```freebasic
SetReadOnly( p, v )
```

## Notes

- portable

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print SetReadOnly( p, true ).IsOk( )      '' true
print Stat( p ).Value( ).IsReadOnly( )    '' true

'' PORTABLE: the read-only attribute on Windows, the owner write bit on
'' POSIX -- each platform's own model, not a translation
print SetReadOnly( p, false ).IsOk( )     '' true

'' Clear it before deleting: a read-only file cannot be removed

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
