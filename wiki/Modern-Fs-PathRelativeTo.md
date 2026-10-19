[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathRelativeTo**

# PathRelativeTo

Returns a path relative to a base folder; fails if the two have different roots.

## Syntax

```freebasic
PathRelativeTo( p, base )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#import "std/fs"
using fs

'' THE ONE PATH FUNCTION THAT CAN FAIL, so it returns an FsResult rather
'' than a bare string: there IS no relative path between two different
'' roots, and "..\..\D:\b" would be a fabrication.
dim r as FsResultUStr = PathRelativeTo( "C:\dev\src\main.tiko", "C:\dev" )

if r.IsOk( ) then print r.Value( )       '' src\main.tiko

'' It walks UP with .. when it has to
dim up as FsResultUStr = PathRelativeTo( "C:\dev\inc", "C:\dev\src" )
if up.IsOk( ) then print up.Value( )     '' ..\inc

'' Different drives have no relative path between them
dim bad as FsResultUStr = PathRelativeTo( "C:\a", "D:\b" )
print bad.IsOk( )                        '' false
print bad.Failure( ).Code( ) = FS_INVALID_PATH       '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
