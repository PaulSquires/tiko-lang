[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.Path**

# DirEntry.Path

the full path, directly usable

## Syntax

```freebasic
DirEntry.Path( )
```

## Notes

- the full path, directly usable

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

'' The FULL path, directly usable -- no joining needed at the call site
for each r in ReadDir( dir_ )
    if r.IsOk( ) then
        if r.Value( ).IsFile( ) then
            print ReadAllText( r.Value( ).Path( ) ).IsOk( )       '' true
        end if
    end if
next

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
