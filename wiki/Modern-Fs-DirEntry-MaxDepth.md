[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.MaxDepth**

# DirEntry.MaxDepth

## Syntax

```freebasic
DirEntry.MaxDepth
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

'' A WalkOptions field, DEFAULT 0 = UNBOUNDED -- zero does not mean
'' "the top level only"
dim opts as WalkOptions
print opts.MaxDepth          '' 0

opts.MaxDepth = 1
dim as int32 n = 0
for each r in WalkDir( dir_, opts )
    n += 1
next
print n                      '' 3 -- depth 0 only: a.txt, b.txt, sub

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
