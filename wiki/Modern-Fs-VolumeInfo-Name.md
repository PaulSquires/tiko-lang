[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **VolumeInfo.Name**

# VolumeInfo.Name

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
VolumeInfo.Name
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim v as VolumeInfo = GetVolumeInfo( "." ).Value( )

'' THE LABEL, AND IT MAY BE EMPTY -- always is on Linux, where reading
'' one portably would mean linking blkid, and often is for a network
'' share on Windows. Never assert on it; print it only as decoration.
print len( v.Name ) >= 0     '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
