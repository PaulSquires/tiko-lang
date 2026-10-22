[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **WriteAllBytes**

# WriteAllBytes

Writes an Array of bytes to a file, creating the file or replacing it.

## Syntax

```freebasic
WriteAllBytes( p, buf )
```

## Notes

- FsResultBool

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

dim buf as Array( of uint8 )
buf.Push( 65 ) : buf.Push( 66 )

print WriteAllBytes( p, buf ).IsOk( )    '' true
print ReadAllText( p ).Value( )          '' AB

'' Truncates like WriteAllText, and writes exactly the bytes given --
'' no encoding step, no line-ending translation

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [File Streams](Category-File-Streams)  
**Documented under:** File Operations
