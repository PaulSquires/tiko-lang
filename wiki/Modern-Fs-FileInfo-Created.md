[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.Created**

# FileInfo.Created

chrono.Instant

## Syntax

```freebasic
FileInfo.Created( )
```

## Notes

- The creation (birth) time as a chrono.Instant -- meaningful only when HasCreated( ).

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as FileInfo fi = Stat( p ).Value( )
if fi.HasCreated( ) then print cbool( fi.Created( ).Ticks = fi.CreatedUtc( ) )    '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
