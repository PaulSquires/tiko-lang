[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateDirAll**

# CreateDirAll

mkdir -p; SUCCEEDS if it is already a directory

## Syntax

```freebasic
CreateDirAll( p )
```

## Notes

- mkdir -p; SUCCEEDS if it is already a directory

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' mkdir -p: creates every missing parent
dim as ustring deep = PathJoin( dir_, "a", "b", "c" )

print CreateDirAll( deep ).IsOk( )       '' true
print IsDir( deep )                      '' true

'' And it SUCCEEDS when the directory is already there, which is the
'' difference from CreateDir -- so it is the one to call when you want
'' the directory to exist rather than to have made it
print CreateDirAll( deep ).IsOk( )       '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
