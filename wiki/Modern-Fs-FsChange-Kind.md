[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsChange.Kind**

# FsChange.Kind

FsChangeKind

## Syntax

```freebasic
FsChange.Kind( )
```

## Notes

- FsChangeKind

## Examples

```freebasic
#import "std/fs"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim w as FileWatcher
w.Start( dir_ )
WriteAllText( PathJoin( dir_, "new.txt" ), "x" )

dim changes as Array( of FsChange )
w.Poll( changes, 500 )

for i as int32 = 0 to changes.Count - 1
    '' Created, Modified, Removed or Renamed
    print changes[ i ].Kind( ) >= 0       '' -1 (true)
next
print "polled"

w.Stop( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
