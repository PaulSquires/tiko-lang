[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.OwnerUid**

# FileInfo.OwnerUid

ulong

## Syntax

```freebasic
FileInfo.OwnerUid( )
```

## Notes

- The owner's user id; 0 unless HasOwner( ).

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as FileInfo fi = Stat( p ).Value( )
print iif( fi.HasOwner( ), "owned", "no owner here" )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
