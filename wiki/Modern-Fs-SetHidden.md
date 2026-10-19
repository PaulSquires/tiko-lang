[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetHidden**

# SetHidden

Sets or clears a file's hidden flag on Windows; fails as unsupported on Linux.

## Syntax

```freebasic
SetHidden( p, v )
```

## Notes

- portable IN NAME ONLY

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print SetHidden( p, true ).IsOk( )         '' true
print Stat( p ).Value( ).IsHidden( )       '' true

'' PORTABLE IN NAME ONLY. On Windows it sets an attribute; ON POSIX
'' HIDDEN MEANS A LEADING DOT, so this RENAMES the file -- and the path
'' you were holding no longer names it.
SetHidden( p, false )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions
