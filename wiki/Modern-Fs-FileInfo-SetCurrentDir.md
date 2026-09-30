[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.SetCurrentDir**

# FileInfo.SetCurrentDir

FsResultBool

## Syntax

```freebasic
SetCurrentDir( p )
```

## Notes

- FsResultBool

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim as ustring was = CurrentDir( ).Value( )

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
print SetCurrentDir( td.Value( ) ).IsOk( )       '' true

'' PROCESS-WIDE: every thread sees it, and a relative path anywhere in
'' the program now resolves somewhere else. Put it back.
SetCurrentDir( was )
print PathEquals( CurrentDir( ).Value( ), was )  '' true

RemoveDirAll( td.Value( ) )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
