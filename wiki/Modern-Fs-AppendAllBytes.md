[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **AppendAllBytes**

# AppendAllBytes

FsResultBool

## Syntax

```freebasic
AppendAllBytes( p, buf )
```

## Notes

- Appends buf, an Array( of ubyte ), creating p if needed. Each write lands at the end, atomically per write.

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as containers.Array( of ubyte ) b
b.Push( 65 ) : b.Push( 66 )
AppendAllBytes( p, b )
AppendAllBytes( p, b )
print ReadAllText( p ).Value( )    '' ABAB
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** File Operations
