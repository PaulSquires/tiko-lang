[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateTempFile**

# CreateTempFile

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

CREATES it and returns the path

## Syntax

```freebasic
CreateTempFile( [ prefix ] )
```

## Notes

- CREATES it and returns the path

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim r as FsResultUStr = CreateTempFile( "fbdoc" )
dim as ustring p = r.Value( )

print r.IsOk( )              '' true
print IsFile( p )            '' true -- it exists, empty, already created

WriteAllText( p, "hello" )
print ReadAllText( p ).Value( )          '' hello

'' Created atomically, and NOT deleted automatically
RemoveFile( p )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
