[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.IsReadOnly**

# VolumeInfo.IsReadOnly

## Syntax

```freebasic
VolumeInfo.IsReadOnly
```

## Examples

```freebasic
#import "std/fs"
using fs

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

print v.IsReadOnly           '' false for an ordinary working volume

'' A whole-volume property: a mounted ISO or a write-protected card is
'' read-only however the individual files are marked
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
