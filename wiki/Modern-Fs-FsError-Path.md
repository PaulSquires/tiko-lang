[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.Path**

# FsError.Path

the path the call was operating on. Empty if none.

## Syntax

```freebasic
FsError.Path( )
```

## Notes

- the path the call was operating on. Empty if none.

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "missing.txt" )

print e.Path( )              '' missing.txt

'' The path the call was operating on. Empty when the failure had no
'' path -- so it can be printed unconditionally.
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
