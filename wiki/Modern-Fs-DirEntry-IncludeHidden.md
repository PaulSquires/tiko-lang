[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.IncludeHidden**

# DirEntry.IncludeHidden

## Syntax

```freebasic
DirEntry.IncludeHidden
```

## Examples

```freebasic
#import "std/fs"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
WriteAllText( PathJoin( dir_, "a.txt" ), "aaa" )
WriteAllText( PathJoin( dir_, "b.txt" ), "bb" )
CreateDir( PathJoin( dir_, "sub" ) )
WriteAllText( PathJoin( dir_, "sub", "c.txt" ), "c" )

'' A WalkOptions field, DEFAULT TRUE. Hidden entries ARE included:
'' excluding them would silently omit .git and every hidden system
'' directory, which is another way for a walk to lie about its coverage.
'' Go, Rust and Python all include them.
dim opts as WalkOptions
print opts.IncludeHidden     '' true

opts.IncludeHidden = false
dim as int32 n = 0
for each r in WalkDir( dir_, opts )
    n += 1
next
print n                      '' 4 -- nothing hidden in this tree

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
