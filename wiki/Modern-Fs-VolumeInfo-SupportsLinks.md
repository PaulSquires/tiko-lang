[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.SupportsLinks**

# VolumeInfo.SupportsLinks

## Syntax

```freebasic
VolumeInfo.SupportsLinks
```

## Examples

```freebasic
#import "std/fs"
using fs

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

print v.SupportsLinks        '' true on NTFS

'' BEST EFFORT, AND ASYMMETRIC: a FALSE is reliable, a TRUE is not a
'' guarantee. Windows reports FILE_SUPPORTS_REPARSE_POINTS honestly;
'' Linux has no portable probe, so everything but the FAT family and
'' ISO 9660 is assumed able.
''
'' A caller that is wrong finds out from CreateSymlink -- which is the
'' authority, and needs privilege on Windows anyway
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
