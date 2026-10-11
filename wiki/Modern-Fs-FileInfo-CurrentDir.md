[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.CurrentDir**

# FileInfo.CurrentDir

FsResultUStr

## Syntax

```freebasic
CurrentDir( )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#import "std/fs"
using fs

dim r as FsResultUStr = CurrentDir( )

print r.IsOk( )              '' true
print PathIsAbsolute( r.Value( ) )       '' true
print IsDir( r.Value( ) )                '' true

'' PROCESS-WIDE STATE, and therefore not thread-safe: another thread can
'' change it between this call and the next. Prefer absolute paths to
'' relying on it.
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
