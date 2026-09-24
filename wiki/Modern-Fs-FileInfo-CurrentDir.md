[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.CurrentDir**

# FileInfo.CurrentDir

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultUStr

## Syntax

```freebasic
CurrentDir( )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim r as FsResultUStr = CurrentDir( )

print r.IsOk( )              '' true
print PathIsAbsolute( r.Value( ) )       '' true
print IsDir( r.Value( ) )                '' true

'' PROCESS-WIDE STATE, and therefore not thread-safe: another thread can
'' change it between this call and the next. Prefer absolute paths to
'' relying on it.
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
