[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CopyDir**

# CopyDir

FsResultI64, the number created

## Syntax

```freebasic
CopyDir( src, dst )
CopyDir( src, dst, opts )
```

## Notes

- FsResultI64, the number created

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

CreateDirAll( PathJoin( dir_, "src", "inner" ) )
WriteAllText( PathJoin( dir_, "src", "f.txt" ), "x" )

'' Recursive, and it returns the NUMBER OF OBJECTS COPIED
dim r as FsResultI64 = CopyDir( PathJoin( dir_, "src" ), PathJoin( dir_, "dst" ) )
print r.IsOk( )              '' true
print r.Value( ) >= 2        '' -1 (true) -- the file and the inner directory

print IsFile( PathJoin( dir_, "dst", "f.txt" ) )         '' true

'' A CopyOptions overload controls overwriting, timestamps, permissions
'' and symlink handling

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
