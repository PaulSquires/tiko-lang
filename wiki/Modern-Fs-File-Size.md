[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.Size**

# File.Size

Returns the open file's current size in bytes.

## Syntax

```freebasic
File.Size( )
```

## Notes

- The size of the open file now.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
f.WriteUtf8( "abc" )
print f.Size( ).Value( )    '' 3
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
