[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.WalkIterator**

# DirEntry.WalkIterator

## Syntax

```freebasic
WalkIterator( )
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

'' WalkDir's iterator -- the recursive counterpart to DirIterator. It
'' carries the pending-directory stack, which is why a walk needs its
'' own type rather than reusing the flat one.
dim it as WalkIterator = WalkDir( dir_ ).GetIterator( )

dim as int32 n = 0
while it.IsValid( )
    n += 1
    it.MoveNext( )
wend
print n                      '' 4 -- three files and one directory

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
