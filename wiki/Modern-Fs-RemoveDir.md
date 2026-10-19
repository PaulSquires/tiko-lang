[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **RemoveDir**

# RemoveDir

Deletes an empty folder; fails if it still holds anything.

## Syntax

```freebasic
RemoveDir( p )
```

## Notes

- FS_DIR_NOT_EMPTY on a populated directory

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring sub_ = PathJoin( dir_, "one" )
CreateDir( sub_ )

print RemoveDir( sub_ ).IsOk( )          '' true
print Exists( sub_ )                     '' false

'' EMPTY DIRECTORIES ONLY -- a non-empty one fails rather than taking
'' its contents with it
CreateDir( sub_ )
WriteAllText( PathJoin( sub_, "f.txt" ), "x" )
print RemoveDir( sub_ ).IsOk( )          '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
