[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.RootPath**

# VolumeInfo.RootPath

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
VolumeInfo.RootPath
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

print len( v.RootPath ) > 0  '' -1 (true) -- "C:\", "/" or "\\srv\share\"

'' The mount point the queried path lives on, which is what PathRoot
'' would give for a local path and what it cannot give for a mounted
'' subdirectory
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
