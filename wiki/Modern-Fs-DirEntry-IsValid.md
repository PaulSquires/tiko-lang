[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.IsValid**

# DirEntry.IsValid

Returns true while the iterator is on an entry.

## Syntax

```freebasic
DirEntry.IsValid( )
```

## Notes

- still on an element?

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

'' The iterator protocol underneath `for each`: IsValid / Value /
'' MoveNext, the same shape the containers use
dim it as DirIterator = ReadDir( dir_ ).GetIterator( )

print it.IsValid( )          '' true -- there is an entry to read

while it.IsValid( )
    it.MoveNext( )
wend
print it.IsValid( )          '' false -- the directory is exhausted

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
