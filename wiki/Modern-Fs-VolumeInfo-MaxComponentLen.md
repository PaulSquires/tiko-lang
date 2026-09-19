[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.MaxComponentLen**

# VolumeInfo.MaxComponentLen

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
VolumeInfo.MaxComponentLen
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

print v.MaxComponentLen > 0  '' -1 (true) -- 255 on NTFS and on ext4

'' The longest SINGLE COMPONENT, not the longest path -- the two limits
'' are different and only this one is reported here
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
