[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.OpenAppend**

# File.OpenAppend

FsResultBool

## Syntax

```freebasic
File.OpenAppend( p )
```

## Notes

- Append + Create: every write goes to the end, whatever the position.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.OpenAppend( p )
f.WriteUtf8( "a" )
f.Seek( 0 )
f.WriteUtf8( "b" )
f.Close( )
print ReadAllText( p ).Value( )    '' ab

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
