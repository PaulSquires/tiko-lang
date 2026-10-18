[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SameFile**

# SameFile

FsResultBool

## Syntax

```freebasic
SameFile( a, b )
```

## Notes

- Whether a and b are the same file, following links on both.
- A path that does not exist is a failure (FS_NOT_FOUND), not false: "different files" and "could not tell" are different answers.

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
CopyFile( p, PathJoin( dir_, "copy.txt" ) )
print SameFile( p, PathJoin( dir_, "copy.txt" ) ).Value( )    '' false -- a copy is another file
print SameFile( p, p ).Value( )                                '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
