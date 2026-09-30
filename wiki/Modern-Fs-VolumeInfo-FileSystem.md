[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.FileSystem**

# VolumeInfo.FileSystem

## Syntax

```freebasic
VolumeInfo.FileSystem
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

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
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
