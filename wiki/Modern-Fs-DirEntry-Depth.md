[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.Depth**

# DirEntry.Depth

0 for the immediate children of the walk root

## Syntax

```freebasic
DirEntry.Depth( )
```

## Notes

- 0 for the immediate children of the walk root

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
WriteAllText( PathJoin( dir_, "a.txt" ), "aaa" )
WriteAllText( PathJoin( dir_, "b.txt" ), "bb" )
CreateDir( PathJoin( dir_, "sub" ) )
WriteAllText( PathJoin( dir_, "sub", "c.txt" ), "c" )

'' How far below the walk root this entry is. The root's own children
'' are depth 0.
for each r in WalkDir( dir_ )
    if r.IsOk( ) then
        print r.Value( ).Depth( ) & " " & r.Value( ).Name( )
    end if
next                         '' 0 a.txt / 0 b.txt / 0 sub / 1 c.txt

'' Under ReadDir every entry is depth 0, since it does not descend

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
