[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkOptions.Filter**

# WalkOptions.Filter

Sets a function that decides, entry by entry, what a walk returns and what it enters.

## Syntax

```freebasic
WalkOptions.Filter / WalkOptions.FilterUser
```

## Notes

- Filter is a [WalkFilter](Modern-Fs-WalkFilter), nullptr (yield and descend everything) by default. FilterUser is passed to it untouched: a pointer to your own state.

## Examples

```freebasic
#import "std/fs"
using fs

function CountAll( byref e as const DirEntry, byval user as any ptr ) as long
    *cptr( long ptr, user ) += 1
    return WALK_ALL
end function

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
CreateDirAll( PathJoin( dir_, "src" ) )
CreateDirAll( PathJoin( dir_, "build" ) )
WriteAllText( PathJoin( dir_, "src", "main.tiko" ), "x" )
WriteAllText( PathJoin( dir_, "build", "main.o" ), "x" )
WriteAllText( PathJoin( dir_, "README" ), "x" )
dim as long count = 0
dim as WalkOptions o
o.Filter = @CountAll
o.FilterUser = @count
for each e in WalkDir( dir_, o ) : next
print count    '' 5
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
