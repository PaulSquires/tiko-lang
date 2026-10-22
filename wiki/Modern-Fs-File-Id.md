[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.Id**

# File.Id

Returns the FileId of the open file, still right after a rename.

## Syntax

```freebasic
File.Id( )
```

## Notes

- The FileId of the file this File has open -- still right if the file has been renamed since it was opened.

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as File f
f.OpenRead( p )
print f.Id( ).Value( ) = GetFileId( p ).Value( )    '' true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Metadata
