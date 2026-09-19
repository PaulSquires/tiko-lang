[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetWin32Attributes**

# SetWin32Attributes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
SetWin32Attributes( p, attrs )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' Windows only, and it sets the WHOLE word -- read the current value
'' and modify it, rather than assigning a bare constant, or every other
'' attribute is cleared
dim cur as FsResultULong = GetWin32Attributes( p )

if cur.IsOk( ) then
    const FILE_ATTRIBUTE_HIDDEN = &h2
    print SetWin32Attributes( p, cur.Value( ) or FILE_ATTRIBUTE_HIDDEN ).IsOk( )
    print Stat( p ).Value( ).IsHidden( )  '' true
    SetWin32Attributes( p, cur.Value( ) )
end if

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
