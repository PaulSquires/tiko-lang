[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirIterator.Value**

# DirIterator.Value

Returns the current entry by reference; the next MoveNext makes it invalid.

## Syntax

```freebasic
DirIterator.Value( )
```

## Notes

- BYREF DirEntryResult -- see the warning above

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

dim it as DirIterator = ReadDir( dir_ ).GetIterator( )

'' Value( ) is BYREF and yields a DirEntryResult -- a Result, not a bare
'' entry, because one entry can fail while the rest of the directory is
'' perfectly readable
dim r as DirEntryResult = it.Value( )
print r.IsOk( )              '' true
print len( r.Value( ).Name( ) ) > 0      '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
