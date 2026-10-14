[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **IsFile**

# IsFile

boolean -- follows links

## Syntax

```freebasic
IsFile( p )
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

print IsFile( p )            '' true
print IsFile( dir_ )         '' false -- a directory is not a file
print IsFile( PathJoin( dir_, "nope" ) )         '' false

'' FOLLOWS SYMLINKS, so a link to a file answers true. LStat is the way
'' to ask about the link itself.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
