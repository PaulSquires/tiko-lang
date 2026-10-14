[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetVolumes**

# GetVolumes

FsResultLong; fills Array( of VolumeInfo )

## Syntax

```freebasic
GetVolumes( vols )
```

## Notes

- FsResultLong; fills Array( of VolumeInfo )

## Examples

```freebasic
#import "std/containers"
#import "std/fs"
using fs, containers

'' Every mounted volume, filling an Array
dim vols as Array( of VolumeInfo )
dim r as FsResultLong = GetVolumes( vols )

print r.IsOk( )              '' true
print r.Value( ) >= 1        '' -1 (true) -- at least one
print vols.Count = r.Value( )              '' -1 (true)

for i as int32 = 0 to vols.Count - 1
    print len( vols[ i ].RootPath ) > 0    '' -1 (true) for each
next
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
