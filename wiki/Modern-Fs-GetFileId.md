[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetFileId**

# GetFileId

FsResultId

## Syntax

```freebasic
GetFileId( p [, followLinks ] )
```

## Notes

- The FileId of p, following a symbolic link unless followLinks is false.
- Works for a directory as well as a file.

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
CreateHardLink( p, PathJoin( dir_, "twin.txt" ) )
print GetFileId( p ).Value( ) = GetFileId( PathJoin( dir_, "twin.txt" ) ).Value( )    '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
