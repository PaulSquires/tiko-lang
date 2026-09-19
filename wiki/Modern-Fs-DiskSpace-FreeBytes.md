[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DiskSpace.FreeBytes**

# DiskSpace.FreeBytes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DiskSpace.FreeBytes
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim sp as DiskSpace = GetDiskSpace( "." ).Value( )

'' Free on the volume, IGNORING QUOTA -- the number to REPORT
print sp.FreeBytes <= sp.TotalBytes        '' -1 (true)

'' AvailableBytes is the one to BRANCH on: under a quota it is smaller,
'' and it is what a write will actually be allowed to use
print sp.AvailableBytes <= sp.FreeBytes    '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
