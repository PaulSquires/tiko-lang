[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileLock.IsHeld**

# FileLock.IsHeld

## Syntax

```freebasic
FileLock.IsHeld( )
```

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim lk as FileLock
print lk.IsHeld( )           '' false

lk.Acquire( p )
print lk.IsHeld( )           '' true

lk.Release( )
print lk.IsHeld( )           '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching
