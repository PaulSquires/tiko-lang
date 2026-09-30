[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetHidden**

# SetHidden

portable IN NAME ONLY

## Syntax

```freebasic
SetHidden( p, v )
```

## Notes

- portable IN NAME ONLY

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

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
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
