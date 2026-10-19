[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.DirIterator**

# DirEntry.DirIterator

Holds the iterator ReadDir hands out, for stepping through a folder without for each.

## Syntax

```freebasic
DirIterator( )
```

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

'' What ReadDir's range hands back. Ordinary code writes `for each`
'' and never names this type.
dim it as DirIterator = ReadDir( dir_ ).GetIterator( )

while it.IsValid( )
    if it.Value( ).IsOk( ) then print it.Value( ).Value( ).Name( )
    it.MoveNext( )
wend

'' Name it when the loop needs to stop early, resume, or interleave with
'' another iterator

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
