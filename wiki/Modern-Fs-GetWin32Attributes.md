[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetWin32Attributes**

# GetWin32Attributes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FS_UNSUPPORTED on POSIX

## Syntax

```freebasic
GetWin32Attributes( p )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' The raw dwFileAttributes word. WINDOWS ONLY -- elsewhere it fails
'' rather than inventing a value.
dim r as FsResultULong = GetWin32Attributes( p )

print r.IsOk( )              '' true on Windows
if r.IsOk( ) then print r.Value( ) > 0    '' -1 (true)

'' Code that reads this is platform code by definition. IsReadOnly and
'' IsHidden are the portable questions.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
