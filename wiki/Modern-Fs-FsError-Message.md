[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.Message**

# FsError.Message

a fixed English one-liner derived from Code( ).

## Syntax

```freebasic
FsError.Message( )
```

## Notes

- a fixed English one-liner derived from Code( ).

## Examples

```freebasic
#import "std/fs"
using FB

dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "missing.txt" )

print e.Message( )           '' a fixed English one-liner for the CODE

'' Derived from Code( ), NOT from the OS -- so it does not change with
'' the machine's language and is safe to compare in a test. It is not
'' the OS's own message text.
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
