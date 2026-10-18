[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkFilter**

# WalkFilter

The type of WalkOptions.Filter.

## Syntax

```freebasic
type WalkFilter as function( byref e as const DirEntry, byval user as any ptr ) as long
```

## Notes

- Called once for every entry the walk reaches, with WalkOptions.FilterUser, returning WalkDecision bits.
- An entry is yielded only when the options AND the filter both allow it, and walked into only when both do -- so a filter can prune a directory that YieldDirectories = FALSE would never show.
- This is how a for each loop prunes: its body cannot reach the iterator.

## Examples

```freebasic
#import "std/fs"
using fs

function NoBuild( byref e as const DirEntry, byval user as any ptr ) as long
    if e.Name( ) = "build" then return WALK_SKIP    '' neither shown nor entered
    return WALK_ALL
end function

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
CreateDirAll( PathJoin( dir_, "src" ) )
CreateDirAll( PathJoin( dir_, "build" ) )
WriteAllText( PathJoin( dir_, "src", "main.tiko" ), "x" )
WriteAllText( PathJoin( dir_, "build", "main.o" ), "x" )
WriteAllText( PathJoin( dir_, "README" ), "x" )
dim as WalkOptions o
o.Filter = @NoBuild
for each e in WalkDir( dir_, o )
    print e.Value( ).Name( )
next
'' README, src, main.tiko -- in some order; build and main.o skipped
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
