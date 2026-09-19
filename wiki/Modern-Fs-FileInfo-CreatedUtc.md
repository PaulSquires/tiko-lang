[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.CreatedUtc**

# FileInfo.CreatedUtc

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
FileInfo.CreatedUtc( )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim info as FileInfo = Stat( p ).Value( )

'' NOT EVERY PLATFORM HAS ONE. Check HasCreated before reading it, or a
'' zero from a filesystem that does not record creation looks like
'' 0001-01-01.
if info.HasCreated( ) then
    print info.CreatedUtc( ) > 0         '' -1 (true) on Windows
end if
print info.HasCreated( )                 '' true on Windows

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
