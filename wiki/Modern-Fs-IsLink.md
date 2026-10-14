[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **IsLink**

# IsLink

boolean

## Syntax

```freebasic
IsLink( p )
```

## Notes

- boolean

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' Does NOT follow: it asks whether the path itself is a symlink
print IsLink( p )            '' false -- an ordinary file

'' Creating a symlink needs privilege on Windows, so this example does
'' not make one. IsLink is the guard to use before ReadLink, and the
'' reason LStat exists beside Stat.
print IsLink( dir_ )         '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions
