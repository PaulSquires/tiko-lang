[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.YieldDirectories**

# DirEntry.YieldDirectories

## Syntax

```freebasic
DirEntry.YieldDirectories
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

'' A WalkOptions field, DEFAULT TRUE: directories are yielded as well
'' as files, before their contents
dim opts as WalkOptions
print opts.YieldDirectories  '' true

opts.YieldDirectories = false
dim as int32 n = 0
for each r in WalkDir( dir_, opts )
    n += 1
next
print n                      '' 3 -- the files only; sub is still descended

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
