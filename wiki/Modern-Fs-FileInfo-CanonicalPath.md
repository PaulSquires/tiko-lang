[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.CanonicalPath**

# FileInfo.CanonicalPath

FsResultUStr

## Syntax

```freebasic
CanonicalPath( p )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#import "std/fs"
using FB

'' ASKS THE FILESYSTEM: it resolves every symlink and returns the real
'' path, so it FAILS when the path does not exist
dim r as FsResultUStr = CanonicalPath( "." )

print r.IsOk( )              '' true
print PathIsAbsolute( r.Value( ) )       '' true

dim miss as FsResultUStr = CanonicalPath( "no_such_thing" )
print miss.IsOk( )                       '' false

'' AbsolutePath is the textual one that cannot fail this way
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
