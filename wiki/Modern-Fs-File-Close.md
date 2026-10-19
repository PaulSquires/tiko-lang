[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.Close**

# File.Close

Closes the file and reports any error the close itself raised.

## Syntax

```freebasic
File.Close( )
```

## Notes

- Closes the handle and reports the close's own error, which is where a network filesystem reports a write that failed late. The destructor closes too, but has nowhere to report an error.
- The handle is gone afterwards either way. Closing a closed File is Ok.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
print f.Close( ).IsOk( ), f.IsOpen( )    '' true false
print f.Close( ).IsOk( )               '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
