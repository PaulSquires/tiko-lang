[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.Code**

# FsError.Code

FsErrorCode -- the portable code. Branch on this.

## Syntax

```freebasic
FsError.Code( )
```

## Notes

- FsErrorCode -- the portable code. Branch on this.

## Examples

```freebasic
#import "std/numeric"
#import "std/fs"
using fs, numeric

'' Every failing FS call returns a result carrying one of these
dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "missing.txt" )

print e.Code( ) = FS_NOT_FOUND           '' -1 (true)

'' The PORTABLE code -- the same value on every platform for the same
'' condition, which OsCode( ) is not
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
