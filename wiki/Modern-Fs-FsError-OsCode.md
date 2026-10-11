[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FsError.OsCode**

# FsError.OsCode

GetLastError( ) / errno, VERBATIM and unmapped. Zero when

## Syntax

```freebasic
FsError.OsCode( )
```

## Notes

- GetLastError( ) / errno, VERBATIM and unmapped. Zero when

## Examples

```freebasic
#import "std/numeric"
#import "std/fs"
using fs, numeric

dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "missing.txt" )

print e.OsCode( )            '' 2 -- ERROR_FILE_NOT_FOUND on Windows

'' THE RAW PLATFORM NUMBER, unmapped: a Win32 error here, an errno
'' elsewhere. For logging and for looking up in the platform's own
'' documentation -- never for branching, since it is not portable.
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Errors  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
