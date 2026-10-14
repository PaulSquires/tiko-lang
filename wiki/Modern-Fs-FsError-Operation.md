[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.Operation**

# FsError.Operation

"CreateFileW", "unlink", "CopyDir". For diagnostics, NEVER

## Syntax

```freebasic
FsError.Operation( )
```

## Notes

- "CreateFileW", "unlink", "CopyDir". For diagnostics, NEVER

## Examples

```freebasic
#import "std/numeric"
#import "std/fs"
using fs, numeric

dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "missing.txt" )

print e.Operation( )         '' CreateFileW

'' The NAME OF THE CALL THAT FAILED -- "CreateFileW", "unlink",
'' "CopyDir". FOR DIAGNOSTICS ONLY: it is a platform detail and will
'' differ between them, so never branch on it.
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors
