[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.AbsolutePath**

# FileInfo.AbsolutePath

FsResultUStr

## Syntax

```freebasic
AbsolutePath( p )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#import "std/fs"
using FB

'' PURELY TEXTUAL apart from needing the current directory: it prefixes
'' the working directory and normalises, and never asks whether the path
'' exists
dim r as FsResultUStr = AbsolutePath( "src" )

print r.IsOk( )              '' true
print PathIsAbsolute( r.Value( ) )       '' true

'' It works on a path that is not there, which is what makes it
'' different from CanonicalPath
print AbsolutePath( "no_such_thing" ).IsOk( )    '' true
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
