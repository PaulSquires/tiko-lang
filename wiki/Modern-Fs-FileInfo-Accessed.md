[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.Accessed**

# FileInfo.Accessed

chrono.Instant

## Syntax

```freebasic
FileInfo.Accessed( )
```

## Notes

- The last-access time as a chrono.Instant -- meaningful only when HasAccessed( ), and often not updated at all (relatime, NTFS defaults).

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as FileInfo fi = Stat( p ).Value( )
print cbool( fi.Accessed( ).Ticks = fi.AccessedUtc( ) )    '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
