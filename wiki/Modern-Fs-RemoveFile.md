[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **RemoveFile**

# RemoveFile

Deletes a file; fails if it is not there.

## Syntax

```freebasic
RemoveFile( p )
```

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )

print RemoveFile( p ).IsOk( )            '' true
print Exists( p )                        '' false

'' Removing something that is not there FAILS -- it is not a no-op, so
'' check Exists first if that is what you meant
dim again as FsResultBool = RemoveFile( p )
print again.IsOk( )                      '' false
print again.Failure( ).Code( ) = FS_NOT_FOUND    '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
