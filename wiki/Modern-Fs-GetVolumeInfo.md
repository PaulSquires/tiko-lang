[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetVolumeInfo**

# GetVolumeInfo

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultVol

## Syntax

```freebasic
GetVolumeInfo( p )
```

## Notes

- FsResultVol

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim r as FsResultVol = GetVolumeInfo( "." )

print r.IsOk( )              '' true

dim v as VolumeInfo = r.Value( )
print len( v.RootPath ) > 0  '' -1 (true)
print v.MaxComponentLen > 0  '' -1 (true)

'' Name and FileSystem MAY BE EMPTY -- always on Linux, often for a
'' network share -- so never assert on them
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
