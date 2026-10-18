[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReadAllBytes**

# ReadAllBytes

FsResultI64 -- fills Array( of ubyte )

## Syntax

```freebasic
ReadAllBytes( p, buf )
ReadAllBytes( p, buf, maxBytes )    '' FS_TOO_LARGE above maxBytes, before anything is read
```

## Notes

- FsResultI64 -- fills Array( of ubyte )

## Examples

```freebasic
#import "std/containers"
#import "std/fs"
using fs, containers

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.bin" )
WriteAllText( p, "AB" )

dim buf as Array( of uint8 )
dim r as FsResultI64 = ReadAllBytes( p, buf )

print r.IsOk( )              '' true
print r.Value( )             '' 2 -- the byte count
print buf[ 0 ] & " " & buf[ 1 ]          '' 65 66

'' Bytes, with no encoding assumed -- for anything that is not text

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
