[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.IsSymlink**

# DirEntry.IsSymlink

## Syntax

```freebasic
DirEntry.IsSymlink( )
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

'' The entry is a symlink ITSELF -- the walk does not follow it by
'' default, so this is how a link is recognised rather than descended
for each r in ReadDir( dir_ )
    if r.IsOk( ) then
        if r.Value( ).IsSymlink( ) then print r.Value( ).Name( )
    end if
next                         '' nothing here: no links in this tree
print "done"

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
