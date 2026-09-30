[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileWatcher.Poll**

# FileWatcher.Poll

FsResultLong -- the count

## Syntax

```freebasic
FileWatcher.Poll( changes, [ timeoutMs ] )
```

## Notes

- FsResultLong -- the count

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim w as FileWatcher
w.Start( dir_ )

WriteAllText( PathJoin( dir_, "new.txt" ), "x" )

'' Collects the changes seen so far. The timeout is in milliseconds;
'' 0 returns immediately with whatever is queued.
dim changes as Array( of FsChange )
dim r as FsResultLong = w.Poll( changes, 500 )

print r.IsOk( )              '' true
print r.Value( ) >= 0        '' -1 (true) -- how many changes came back

w.Stop( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
