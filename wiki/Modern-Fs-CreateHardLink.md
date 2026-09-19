[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateHardLink**

# CreateHardLink

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultBool

## Syntax

```freebasic
CreateHardLink( target, lnk )
```

## Notes

- FsResultBool

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim as ustring lnk = PathJoin( dir_, "same.txt" )
dim r as FsResultBool = CreateHardLink( p, lnk )

if r.IsOk( ) then
    '' A second NAME for one file, not a copy and not a link object
    print ReadAllText( lnk ).Value( )        '' hello
    print IsLink( lnk )                      '' false -- it is not a symlink
    print LinkCount( p ).Value( )            '' 2
else
    print "not supported here: " & r.Failure( ).Message( )
end if

'' Both names must be on the SAME VOLUME, and neither is "the original"

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
