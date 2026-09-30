[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.MaxComponentLen**

# VolumeInfo.MaxComponentLen

## Syntax

```freebasic
VolumeInfo.MaxComponentLen
```

## Examples

```freebasic
#import "std/fs"
using FB

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

print v.MaxComponentLen > 0  '' -1 (true) -- 255 on NTFS and on ext4

'' The longest SINGLE COMPONENT, not the longest path -- the two limits
'' are different and only this one is reported here
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
