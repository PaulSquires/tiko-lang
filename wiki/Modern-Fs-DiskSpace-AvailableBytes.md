[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DiskSpace.AvailableBytes**

# DiskSpace.AvailableBytes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DiskSpace.AvailableBytes
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim sp as DiskSpace = GetDiskSpace( "." ).Value( )

'' FREE TO THIS USER -- the one to branch on before writing, because a
'' quota can make it far smaller than FreeBytes
print sp.AvailableBytes <= sp.FreeBytes    '' -1 (true)

dim as ulongint need = 1024
if sp.AvailableBytes > need then print "room to write"
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
