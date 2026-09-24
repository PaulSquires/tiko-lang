[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetPosixMode**

# GetPosixMode

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetPosixMode( p )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' THE POSIX PERMISSION BITS, AND POSIX ONLY. Off that platform it
'' returns FS_UNSUPPORTED rather than inventing a value -- so this is
'' one to branch on ONCE AT STARTUP, not to treat as a transient
'' failure.
dim r as FsResultULong = GetPosixMode( p )

print r.IsOk( )              '' FALSE on Windows

if r.IsOk( ) then
    print r.Value( ) > 0
else
    print r.Failure( ).Code( ) = FS_UNSUPPORTED      '' -1 (true) on Windows
end if

'' Calling Value( ) on that failed Result RAISES -- IsOk is not
'' optional here. IsReadOnly is the portable question.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
