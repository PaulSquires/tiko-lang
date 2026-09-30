[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReadLink**

# ReadLink

FsResultUStr

## Syntax

```freebasic
ReadLink( lnk )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#import "std/fs"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' The target a symlink points at, WITHOUT following it or checking
'' that it exists -- a dangling link still reads
dim as ustring lnk = PathJoin( dir_, "link.txt" )

if CreateSymlink( p, lnk ).IsOk( ) then
    print ReadLink( lnk ).Value( ) = p       '' -1 (true)
end if

'' On something that is not a link it FAILS rather than answering with
'' the path itself
dim r as FsResultUStr = ReadLink( p )
print r.IsOk( )              '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
