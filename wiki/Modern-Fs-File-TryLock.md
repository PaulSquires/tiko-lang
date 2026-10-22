[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.TryLock**

# File.TryLock

Locks the whole file if it is free, or fails at once if another holder has it.

## Syntax

```freebasic
File.TryLock( [ exclusive ] )
```

## Notes

- Lock without waiting: FS_WOULD_BLOCK when another holder has it.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as File a, b
a.OpenRead( p ) : b.OpenRead( p )
a.Lock( )
print cbool( b.TryLock( ).Failure( ).Code( ) = FS_WOULD_BLOCK )    '' true
a.Unlock( )
print b.TryLock( ).IsOk( )    '' true
b.Unlock( )
a.Close( ) : b.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
