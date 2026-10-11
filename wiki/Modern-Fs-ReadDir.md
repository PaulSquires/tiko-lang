[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReadDir**

# ReadDir

one level

## Syntax

```freebasic
ReadDir( p )
```

## Notes

- one level

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

'' ONE LEVEL, lazily: entries come out as the directory is read, so a
'' huge directory does not have to be materialised first
dim as int32 n = 0
for each r in ReadDir( dir_ )
    if r.IsOk( ) then n += 1
next
print n                      '' 3 -- a.txt, b.txt, sub

'' Each element is a RESULT, because an entry can fail on its own -- a
'' file deleted mid-walk does not abandon the rest of the directory

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
