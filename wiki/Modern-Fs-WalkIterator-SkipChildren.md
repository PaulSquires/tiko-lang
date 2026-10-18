[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkIterator.SkipChildren**

# WalkIterator.SkipChildren

## Syntax

```freebasic
WalkIterator.SkipChildren( )
```

## Notes

- Do not walk into the entry just yielded. For an explicit iterator loop; a for each loop prunes with WalkOptions.Filter instead.
- A no-op for anything but a directory the walk was about to enter, and with ContentsFirst, where the contents came first.

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
dim as WalkRange r = WalkDir( dir_, o )
dim as WalkIterator it = r.GetIterator( )
while it.IsValid( )
    print it.Value( ).Value( ).Name( )
    if it.Value( ).Value( ).Name( ) = "build" then it.SkipChildren( )
    it.MoveNext( )
wend
'' README  build  src  main.tiko
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
