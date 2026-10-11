[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.MoveNext**

# DirEntry.MoveNext

advance

## Syntax

```freebasic
DirEntry.MoveNext( )
```

## Notes

- advance

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

dim as int32 n = 0
while it.IsValid( )
    n += 1
    it.MoveNext( )           '' advance; it returns nothing
wend
print n                      '' 3

'' The order is always IsValid -> Value -> MoveNext. Reading an entry
'' does not advance, so Value( ) can be called twice.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
