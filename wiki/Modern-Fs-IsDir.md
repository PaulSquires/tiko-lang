[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **IsDir**

# IsDir

Returns true if the path is a folder, following links; false if it cannot tell.

## Syntax

```freebasic
IsDir( p )
```

## Notes

- boolean -- follows links

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print IsDir( dir_ )          '' true
print IsDir( p )             '' false
print IsDir( PathJoin( dir_, "nope" ) )          '' false

'' Follows symlinks, like IsFile

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
