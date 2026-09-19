[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.FollowSymlinks**

# DirEntry.FollowSymlinks

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DirEntry.FollowSymlinks
```

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

'' A WalkOptions field, DEFAULT FALSE -- and the default is the safe
'' one on purpose: not following makes the traversal a TREE BY
'' CONSTRUCTION, so no cycle is possible and no visited set is needed.
dim opts as WalkOptions
print opts.FollowSymlinks    '' false

'' Following is the dangerous setting: a link to an ancestor makes the
'' walk infinite, and a link out of the tree makes "delete everything
'' under here" delete something else
opts.FollowSymlinks = true

dim as long n = 0
for each r in WalkDir( dir_, opts )
    n += 1
next
print n                      '' 4

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
