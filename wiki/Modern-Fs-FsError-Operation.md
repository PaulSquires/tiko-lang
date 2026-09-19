[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.Operation**

# FsError.Operation

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

"CreateFileW", "unlink", "CopyDir". For diagnostics, NEVER

## Syntax

```freebasic
FsError.Operation( )
```

## Notes

- "CreateFileW", "unlink", "CopyDir". For diagnostics, NEVER

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "missing.txt" )

print e.Operation( )         '' CreateFileW

'' The NAME OF THE CALL THAT FAILED -- "CreateFileW", "unlink",
'' "CopyDir". FOR DIAGNOSTICS ONLY: it is a platform detail and will
'' differ between them, so never branch on it.
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
