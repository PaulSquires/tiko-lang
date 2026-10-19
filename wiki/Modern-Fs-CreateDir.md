[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateDir**

# CreateDir

Creates one folder; fails if something is already there.

## Syntax

```freebasic
CreateDir( p )
```

## Notes

- fails with FS_ALREADY_EXISTS if the target is there

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring sub_ = PathJoin( dir_, "one" )

print CreateDir( sub_ ).IsOk( )          '' true
print IsDir( sub_ )                      '' true

'' FAILS with FS_ALREADY_EXISTS if the target is there -- it is not a
'' silent success, so a caller cannot mistake reuse for creation
dim again as FsResultBool = CreateDir( sub_ )
print again.IsOk( )                      '' false
print again.Failure( ).Code( ) = FS_ALREADY_EXISTS       '' -1 (true)

'' ONE level only: a missing parent is FS_NOT_FOUND
print CreateDir( PathJoin( dir_, "a", "b" ) ).IsOk( )    '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
