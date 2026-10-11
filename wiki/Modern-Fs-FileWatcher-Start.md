[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileWatcher.Start**

# FileWatcher.Start

FsResultBool

## Syntax

```freebasic
FileWatcher.Start( p [, recursive ] )
```

## Notes

- FsResultBool

## Examples

```freebasic
#import "std/fs"
using fs

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

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
