[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileLock.Release**

# FileLock.Release

Releases the lock; harmless when none is held.

## Syntax

```freebasic
FileLock.Release( )
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
lk.Acquire( p )

lk.Release( )
print lk.IsHeld( )           '' false

'' Releasing a lock that is not held is harmless, and the DESTRUCTOR
'' releases -- so a lock cannot outlive its scope even on an early exit
lk.Release( )
print lk.IsHeld( )           '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching
