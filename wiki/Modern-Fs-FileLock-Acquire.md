[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileLock.Acquire**

# FileLock.Acquire

FsResultBool

## Syntax

```freebasic
FileLock.Acquire( p [, exclusive ] [, timeoutMs ] )
```

## Notes

- FsResultBool

## Examples

```freebasic
#import "std/fs"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim lk as FileLock

'' Exclusive by default. The timeout is in milliseconds; -1 waits
'' forever, 0 tries once and gives up.
print lk.Acquire( p ).IsOk( )             '' true
print lk.IsHeld( )                         '' true

lk.Release( )

'' ADVISORY BETWEEN PROCESSES USING THIS API -- it does not stop a
'' program that simply opens the file and writes
print lk.Acquire( p, true, 0 ).IsOk( )    '' true -- free again
lk.Release( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
