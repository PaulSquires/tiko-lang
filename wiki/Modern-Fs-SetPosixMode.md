[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetPosixMode**

# SetPosixMode

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FS_UNSUPPORTED on Windows

## Syntax

```freebasic
SetPosixMode( p, mode )
```

## Notes

- FS_UNSUPPORTED on Windows

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' POSIX ONLY, like GetPosixMode: on Windows every call fails with
'' FS_UNSUPPORTED, including the ones that look harmless.
dim r as FsResultBool = SetPosixMode( p, &o644 )

print r.IsOk( )              '' FALSE on Windows
if r.IsOk( ) = false then
    print r.Failure( ).Code( ) = FS_UNSUPPORTED      '' -1 (true)
end if

'' Use SetReadOnly for the portable question -- it is the read-only
'' attribute on Windows and the owner write bit on POSIX, which is the
'' same operation on each platform's own model
print SetReadOnly( p, true ).IsOk( )      '' true, on both
SetReadOnly( p, false )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
