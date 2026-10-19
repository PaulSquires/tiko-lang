[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TempDir**

# TempDir

Returns the system's temporary folder; creates nothing.

## Syntax

```freebasic
TempDir( )
```

## Notes

- the system temp directory; creates nothing

## Examples

```freebasic
#import "std/fs"
using fs

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
