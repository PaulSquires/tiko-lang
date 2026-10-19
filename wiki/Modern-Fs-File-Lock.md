[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.Lock**

# File.Lock

Locks the whole file, waiting until it is free: exclusive by default, or shared.

## Syntax

```freebasic
File.Lock( [ exclusive ] )
```

## Notes

- Takes a whole-file lock on this handle, waiting until it is free: exclusive by default, shared with false.
- Advisory on POSIX (flock), mandatory on Windows (LockFileEx). A File and a FileLock on the same file exclude each other. Closing the File releases it.
- Calling it again changes the lock's kind; on Windows that releases and retakes it, which is not atomic.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
print f.Lock( ).IsOk( )    '' true
f.Unlock( )
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
