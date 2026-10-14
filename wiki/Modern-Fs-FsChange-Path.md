[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsChange.Path**

# FsChange.Path

the FULL path, not a bare leaf

## Syntax

```freebasic
FsChange.Path( )
```

## Notes

- the FULL path, not a bare leaf

## Examples

```freebasic
#import "std/containers"
#import "std/fs"
using fs, containers

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
    '' THE FULL PATH, not a bare leaf -- so it can be opened without
    '' joining it to the watched directory first
    print PathStartsWith( changes[ i ].Path( ), dir_ )    '' true
next
print "polled"

w.Stop( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching
