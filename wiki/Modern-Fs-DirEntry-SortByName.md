[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkOptions.SortByName**

# WalkOptions.SortByName

## Syntax

```freebasic
WalkOptions.SortByName
```

## Notes

- FALSE by default (the order the system lists). TRUE orders each directory's entries by ORDINAL comparison of Name( ) -- code unit by code unit, the same on every machine and in every locale, so uppercase sorts before lowercase.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
CreateDirAll( PathJoin( dir_, "src" ) )
CreateDirAll( PathJoin( dir_, "build" ) )
WriteAllText( PathJoin( dir_, "src", "main.tiko" ), "x" )
WriteAllText( PathJoin( dir_, "build", "main.o" ), "x" )
WriteAllText( PathJoin( dir_, "README" ), "x" )
dim as WalkOptions o
o.SortByName = true
o.MaxDepth = 1
for each e in WalkDir( dir_, o )
    print e.Value( ).Name( )
next
'' README  build  src
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
