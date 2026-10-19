[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetCurrentDir**

# SetCurrentDir

Changes the program's current folder, for every thread at once.

## Syntax

```freebasic
SetCurrentDir( p )
```

## Notes

- FsResultBool

## Examples

```freebasic
#import "std/fs"
using fs

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
