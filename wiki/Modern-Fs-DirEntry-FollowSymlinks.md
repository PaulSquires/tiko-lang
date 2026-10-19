[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.FollowSymlinks**

# DirEntry.FollowSymlinks

Chooses whether a walk enters linked folders; false by default, so it cannot loop.

## Syntax

```freebasic
DirEntry.FollowSymlinks
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

'' A WalkOptions field, DEFAULT FALSE -- and the default is the safe
'' one on purpose: not following makes the traversal a TREE BY
'' CONSTRUCTION, so no cycle is possible and no visited set is needed.
dim opts as WalkOptions
print opts.FollowSymlinks    '' false

'' Following is the dangerous setting: a link to an ancestor makes the
'' walk infinite, and a link out of the tree makes "delete everything
'' under here" delete something else
opts.FollowSymlinks = true

dim as int32 n = 0
for each r in WalkDir( dir_, opts )
    n += 1
next
print n                      '' 4

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
