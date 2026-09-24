[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TempDir**

# TempDir

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the system temp directory; creates nothing

## Syntax

```freebasic
TempDir( )
```

## Notes

- the system temp directory; creates nothing

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The system temp directory. It CREATES NOTHING -- it only reports
'' where temporary files belong.
dim r as FsResultUStr = TempDir( )

print r.IsOk( )              '' true
print len( r.Value( ) ) > 0  '' -1 (true)
print IsDir( r.Value( ) )    '' true

'' CreateTempFile and CreateTempDir are the ones that make something
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
