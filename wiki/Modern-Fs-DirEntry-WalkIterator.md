[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkIterator**

# WalkIterator

Holds the iterator WalkDir hands out, for stepping through a walk without for each.

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
