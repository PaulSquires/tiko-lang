[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File**

# File

An open file: a Stream over an operating-system handle it owns.

## Syntax

```freebasic
type File extends Stream
    Open( p, opts ) / OpenRead( p ) / Create( p ) / CreateNew( p ) / OpenAppend( p ) / OpenTemp( [ dir ] [, prefix ] )
    Close( ) / IsOpen( ) / Path( )
    Read / Write / Seek / Flush / CanRead / CanWrite / CanSeek      '' Stream
    ReadAt( pos, buf, n ) / WriteAt( pos, buf, n )
    Size( ) / SetSize( n ) / Sync( ) / SyncData( )
    Stat( ) / Lock( [ exclusive ] ) / TryLock( [ exclusive ] ) / Unlock( )
    NativeHandle( )
end type
```

## Notes

- A File is made empty and opened with one of the Open methods; its destructor closes it. Opening a File that is already open is FS_IN_USE.
- It cannot be copied: two values would close one handle twice. Pass it byref.
- Unbuffered: every Read and Write is one system call.
- Every operation on a closed File fails with FS_CLOSED, except Close, IsOpen, Path and NativeHandle.
- Not thread-safe, except ReadAt and WriteAt.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
print f.Create( p ).IsOk( )               '' true
f.WriteUtf8( "hello, file" )
print f.Size( ).Value( )                  '' 11
f.Close( )

print f.OpenRead( p ).IsOk( )             '' true
dim as MemoryStream m
Copy( f, m )
print m.ToUtf8Text( )                     '' hello, file
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
