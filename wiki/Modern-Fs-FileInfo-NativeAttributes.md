[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.NativeAttributes**

# FileInfo.NativeAttributes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

dwFileAttributes / st_mode

## Syntax

```freebasic
FileInfo.NativeAttributes( )
```

## Notes

- dwFileAttributes / st_mode

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' The raw platform word: dwFileAttributes on Windows, st_mode on
'' POSIX. For everything RFC-0007 has not portably abstracted.
dim info as FileInfo = Stat( p ).Value( )

print info.NativeAttributes( ) > 0       '' -1 (true)

'' CODE USING IT IS PLATFORM CODE, by definition -- the bits mean
'' different things on each side. Prefer IsReadOnly, IsHidden and the
'' rest wherever they cover the question.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
