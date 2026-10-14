[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.IsOther**

# DirEntry.IsOther

## Syntax

```freebasic
DirEntry.IsOther( )
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

'' Not a file, not a directory, not a symlink: a device, pipe or socket.
'' The catch-all that keeps the other three honest.
for each r in ReadDir( dir_ )
    if r.IsOk( ) then
        if r.Value( ).IsOther( ) then print r.Value( ).Name( )
    end if
next
print "done"                 '' nothing is 'other' in a plain directory

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
