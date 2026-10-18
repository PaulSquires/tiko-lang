[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.TryLock**

# File.TryLock

FsResultBool

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
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
