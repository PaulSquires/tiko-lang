[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CopyFile**

# CopyFile

overwrite defaults FALSE

## Syntax

```freebasic
CopyFile( src, dst [, overwrite ] )
```

## Notes

- overwrite defaults FALSE

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring a = PathJoin( dir_, "a.txt" )
dim as ustring b = PathJoin( dir_, "b.txt" )
WriteAllText( a, "hello" )

print CopyFile( a, b ).IsOk( )           '' true
print ReadAllText( b ).Value( )          '' hello

'' OVERWRITE DEFAULTS FALSE, so an existing destination is an error
'' rather than a silent replacement
dim again as FsResultBool = CopyFile( a, b )
print again.IsOk( )                      '' false
print again.Failure( ).Code( ) = FS_ALREADY_EXISTS       '' -1 (true)

print CopyFile( a, b, true ).IsOk( )     '' true -- asked for explicitly

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
