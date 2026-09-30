[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **RemoveDirAll**

# RemoveDirAll

rm -rf; FsResultI64, the number of objects removed

## Syntax

```freebasic
RemoveDirAll( p )
```

## Notes

- rm -rf; FsResultI64, the number of objects removed

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' rm -rf, and it returns THE NUMBER OF OBJECTS REMOVED rather than a
'' bare success flag
CreateDirAll( PathJoin( dir_, "a", "b" ) )
WriteAllText( PathJoin( dir_, "a", "f.txt" ), "x" )

dim r as FsResultI64 = RemoveDirAll( PathJoin( dir_, "a" ) )
print r.IsOk( )              '' true
print r.Value( )             '' 3 -- b, f.txt and a itself

print Exists( PathJoin( dir_, "a" ) )    '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
