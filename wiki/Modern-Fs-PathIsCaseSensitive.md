[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathIsCaseSensitive**

# PathIsCaseSensitive

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

compile-time, per platform -- NOT per volume

## Syntax

```freebasic
PathIsCaseSensitive( )
```

## Notes

- compile-time, per platform -- NOT per volume

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' COMPILE-TIME, PER PLATFORM -- not per volume. It answers what the
'' grammar assumes, not what the file system in front of you does.
print PathIsCaseSensitive( )             '' false on Windows

print PathIsCaseSensitive( FB_PATH_POSIX )       '' true
print PathIsCaseSensitive( FB_PATH_WIN32 )       '' false

'' A case-sensitive volume mounted on Windows, or a case-insensitive one
'' on Linux, is not visible here. VolumeInfo.IsCaseSensitive asks the
'' actual volume.
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
