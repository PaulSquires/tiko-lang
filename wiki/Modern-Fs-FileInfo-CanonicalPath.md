[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.CanonicalPath**

# FileInfo.CanonicalPath

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultUStr

## Syntax

```freebasic
CanonicalPath( p )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' ASKS THE FILESYSTEM: it resolves every symlink and returns the real
'' path, so it FAILS when the path does not exist
dim r as FsResultUStr = CanonicalPath( "." )

print r.IsOk( )              '' true
print PathIsAbsolute( r.Value( ) )       '' true

dim miss as FsResultUStr = CanonicalPath( "no_such_thing" )
print miss.IsOk( )                       '' false

'' AbsolutePath is the textual one that cannot fail this way
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
