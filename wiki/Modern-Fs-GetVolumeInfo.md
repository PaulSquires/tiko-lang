[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetVolumeInfo**

# GetVolumeInfo

FsResultVol

## Syntax

```freebasic
GetVolumeInfo( p )
```

## Notes

- FsResultVol

## Examples

```freebasic
#import "std/fs"
using fs

dim r as FsResultVol = GetVolumeInfo( "." )

print r.IsOk( )              '' true

dim v as VolumeInfo = r.Value( )
print len( v.RootPath ) > 0  '' -1 (true)
print v.MaxComponentLen > 0  '' -1 (true)

'' Name and FileSystem MAY BE EMPTY -- always on Linux, often for a
'' network share -- so never assert on them
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
