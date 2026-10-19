[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.FileSystem**

# VolumeInfo.FileSystem

Returns the file system's name, such as NTFS or ext4, or an empty string.

## Syntax

```freebasic
VolumeInfo.FileSystem
```

## Examples

```freebasic
#import "std/fs"
using fs

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

'' "NTFS", "ext4", "exFAT" -- and it MAY BE EMPTY, like Name
print len( v.FileSystem ) >= 0             '' -1 (true)

'' Useful for a diagnostic. For a capability, ask the capability:
'' SupportsLinks, IsCaseSensitive, MaxComponentLen.
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
