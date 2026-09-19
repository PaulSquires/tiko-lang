[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.SupportsLinks**

# VolumeInfo.SupportsLinks

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
VolumeInfo.SupportsLinks
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

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

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
