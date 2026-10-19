[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.NativeHandle**

# File.NativeHandle

Returns the operating-system handle or descriptor, or -1 when closed.

## Syntax

```freebasic
File.NativeHandle( )
```

## Notes

- The HANDLE on Windows, the file descriptor on POSIX; -1 when closed. The File still owns it: do not close it yourself.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
print f.NativeHandle( )    '' -1
f.Create( p )
print cbool( f.NativeHandle( ) <> -1 )    '' true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
