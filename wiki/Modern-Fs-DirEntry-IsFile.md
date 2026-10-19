[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DirEntry.IsFile**

# DirEntry.IsFile

Returns true if the entry is a file; a link reports as a link, not as its target.

## Syntax

```freebasic
DirEntry.IsFile( )
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

for each r in ReadDir( dir_ )
    if r.IsOk( ) then
        if r.Value( ).IsFile( ) then print r.Value( ).Name( )
    end if
next                         '' a.txt / b.txt

'' Answered from the ENUMERATION RECORD where the platform supplies it,
'' so it usually costs no extra syscall -- unlike Info( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
