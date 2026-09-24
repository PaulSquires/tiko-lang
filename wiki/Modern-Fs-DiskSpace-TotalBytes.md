[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DiskSpace.TotalBytes**

# DiskSpace.TotalBytes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DiskSpace.TotalBytes
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim sp as DiskSpace = GetDiskSpace( "." ).Value( )

print sp.TotalBytes > 0      '' -1 (true)

'' The capacity of the VOLUME the path is on -- not of the directory,
'' and not of any quota applied to you
print sp.TotalBytes >= sp.FreeBytes        '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
