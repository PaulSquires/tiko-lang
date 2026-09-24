[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.Path2**

# FsError.Path2

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the second path, for CopyFile / MoveFile / CreateSymlink.

## Syntax

```freebasic
FsError.Path2( )
```

## Notes

- the second path, for CopyFile / MoveFile / CreateSymlink.

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The SECOND path, for the two-path operations: CopyFile, MoveFile,
'' CreateSymlink, ReplaceFile
dim e as FsError = FsError( FS_ALREADY_EXISTS, 183, "CopyFileW", "a.txt" )

print "[" & e.Path2( ) & "]"     '' [] -- empty unless the call had two

'' Which is why a diagnostic should print Path( ) and Path2( ) together
'' rather than assuming one
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
