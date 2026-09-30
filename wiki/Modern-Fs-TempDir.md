[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TempDir**

# TempDir

the system temp directory; creates nothing

## Syntax

```freebasic
TempDir( )
```

## Notes

- the system temp directory; creates nothing

## Examples

```freebasic
#import "std/fs"
using FB

'' The system temp directory. It CREATES NOTHING -- it only reports
'' where temporary files belong.
dim r as FsResultUStr = TempDir( )

print r.IsOk( )              '' true
print len( r.Value( ) ) > 0  '' -1 (true)
print IsDir( r.Value( ) )    '' true

'' CreateTempFile and CreateTempDir are the ones that make something
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
