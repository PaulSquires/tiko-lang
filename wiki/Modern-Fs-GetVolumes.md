[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetVolumes**

# GetVolumes

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultLong; fills Array( of VolumeInfo )

## Syntax

```freebasic
GetVolumes( vols )
```

## Notes

- FsResultLong; fills Array( of VolumeInfo )

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Every mounted volume, filling an Array
dim vols as Array( of VolumeInfo )
dim r as FsResultLong = GetVolumes( vols )

print r.IsOk( )              '' true
print r.Value( ) >= 1        '' -1 (true) -- at least one
print vols.Count = r.Value( )              '' -1 (true)

for i as long = 0 to vols.Count - 1
    print len( vols[ i ].RootPath ) > 0    '' -1 (true) for each
next
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
