[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WriteAllText**

# WriteAllText

FsResultBool

## Syntax

```freebasic
WriteAllText( p, s )
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

dim as ustring p = PathJoin( dir_, "f.txt" )

print WriteAllText( p, "hello" ).IsOk( ) '' true
print ReadAllText( p ).Value( )          '' hello

'' TRUNCATES: it replaces the whole file, it does not append
WriteAllText( p, "bye" )
print ReadAllText( p ).Value( )          '' bye

'' Written as UTF-8, with no BOM

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
