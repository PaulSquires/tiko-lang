[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkDir**

# WalkDir

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

recursive, pre-order

## Syntax

```freebasic
WalkDir( p )
WalkDir( p, opts )
```

## Notes

- recursive, pre-order

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
WriteAllText( PathJoin( dir_, "a.txt" ), "aaa" )
WriteAllText( PathJoin( dir_, "b.txt" ), "bb" )
CreateDir( PathJoin( dir_, "sub" ) )
WriteAllText( PathJoin( dir_, "sub", "c.txt" ), "c" )

'' RECURSIVE and PRE-ORDER: a directory is yielded before its contents
dim as long files_ = 0
for each r in WalkDir( dir_ )
    if r.IsOk( ) then
        if r.Value( ).IsFile( ) then files_ += 1
    end if
next
print files_                 '' 3 -- a.txt, b.txt and sub/c.txt

'' It does NOT follow symlinks by default, which makes the traversal a
'' tree by construction: no cycle is possible and no visited set is
'' needed. A WalkOptions overload changes that and four other things.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
