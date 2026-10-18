[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkOptions.ContentsFirst**

# WalkOptions.ContentsFirst

## Syntax

```freebasic
WalkOptions.ContentsFirst
```

## Notes

- FALSE by default (pre-order: a directory before what is in it). TRUE yields each directory AFTER its contents -- the order a recursive delete needs.
- The root of the walk is never yielded, in either order.

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
o.ContentsFirst = true
o.SortByName = true
for each e in WalkDir( dir_, o )
    print e.Value( ).Name( )
next
'' README  main.o  build  main.tiko  src
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
