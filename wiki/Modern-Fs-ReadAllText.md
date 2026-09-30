[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReadAllText**

# ReadAllText

FsResultUStr

## Syntax

```freebasic
ReadAllText( p )
```

## Notes

- FsResultUStr

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim r as FsResultUStr = ReadAllText( p )
print r.IsOk( )              '' true
print r.Value( )             '' hello

'' A missing file is a FAILURE, not an empty string -- which is the
'' whole point of returning a Result
dim miss as FsResultUStr = ReadAllText( PathJoin( dir_, "nope.txt" ) )
print miss.IsOk( )                       '' false
print miss.Failure( ).Code( ) = FS_NOT_FOUND     '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
