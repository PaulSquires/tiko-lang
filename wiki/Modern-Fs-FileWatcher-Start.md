[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileWatcher.Start**

# FileWatcher.Start

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultBool

## Syntax

```freebasic
FileWatcher.Start( p [, recursive ] )
```

## Notes

- FsResultBool

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim w as FileWatcher

'' Non-recursive by default; pass TRUE to watch subdirectories too
print w.Start( dir_ ).IsOk( )             '' true
print w.IsWatching( )                      '' true

w.Stop( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
