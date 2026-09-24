[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stat**

# Stat

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultInfo -- FOLLOWS symbolic links

## Syntax

```freebasic
Stat( p )
```

## Notes

- FsResultInfo -- FOLLOWS symbolic links

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim r as FsResultInfo = Stat( p )

print r.IsOk( )              '' true
print r.Value( ).Size( )     '' 5
print r.Value( ).IsFile( )   '' true

'' ONE syscall for everything: size, kind, times and attributes come
'' back together, so a loop over a directory does not stat each file
'' repeatedly to ask it three questions.
''
'' FOLLOWS SYMLINKS. LStat is the same call that does not.
dim miss as FsResultInfo = Stat( PathJoin( dir_, "nope" ) )
print miss.IsOk( )                       '' false
print miss.Failure( ).Code( ) = FS_NOT_FOUND     '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
