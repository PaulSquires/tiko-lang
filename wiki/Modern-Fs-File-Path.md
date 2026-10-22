[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.Path**

# File.Path

Returns the path the file was opened with.

## Syntax

```freebasic
File.Path( )
```

## Notes

- The path as it was given to Open, or as OpenTemp made it.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
print PathFileName( f.Path( ) )    '' f.txt
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
