[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.OwnerGid**

# FileInfo.OwnerGid

Returns the owner's group id, or 0 unless HasOwner is true.

## Syntax

```freebasic
FileInfo.OwnerGid( )
```

## Notes

- The owner's group id; 0 unless HasOwner( ).

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as FileInfo fi = Stat( p ).Value( )
print cbool( fi.OwnerGid( ) = fi.OwnerGid( ) )    '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
