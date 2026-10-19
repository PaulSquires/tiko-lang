[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **OpenOptionsAppend**

# OpenOptionsAppend

Returns the OpenOptions for adding to the end of a file, creating it if needed.

## Syntax

```freebasic
OpenOptionsAppend( )
```

## Notes

- Append + Create: every write lands at the end, atomically per write.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Open( p, OpenOptionsAppend( ) )
f.WriteUtf8( "one " )
f.WriteUtf8( "two" )
f.Close( )
print ReadAllText( p ).Value( )    '' one two

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
