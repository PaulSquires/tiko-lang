[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **AppendAllText**

# AppendAllText

FsResultBool

## Syntax

```freebasic
AppendAllText( p, s )
```

## Notes

- FsResultBool

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "log.txt" )

WriteAllText( p, "one" )
AppendAllText( p, " two" )
print ReadAllText( p ).Value( )          '' one two

'' It CREATES the file when it is not there, so an append-only log needs
'' no separate first-write case
dim as ustring fresh = PathJoin( dir_, "new.txt" )
AppendAllText( fresh, "first" )
print ReadAllText( fresh ).Value( )      '' first

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
