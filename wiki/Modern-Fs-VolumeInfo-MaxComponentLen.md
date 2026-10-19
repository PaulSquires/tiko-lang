[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.MaxComponentLen**

# VolumeInfo.MaxComponentLen

Returns the longest file or folder name the volume allows, not the longest path.

## Syntax

```freebasic
VolumeInfo.MaxComponentLen
```

## Examples

```freebasic
#import "std/fs"
using fs

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

print v.MaxComponentLen > 0  '' -1 (true) -- 255 on NTFS and on ext4

'' The longest SINGLE COMPONENT, not the longest path -- the two limits
'' are different and only this one is reported here
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
