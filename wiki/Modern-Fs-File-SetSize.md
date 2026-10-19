[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.SetSize**

# File.SetSize

Truncates the file to a size, or extends it with zero bytes.

## Syntax

```freebasic
File.SetSize( n )
```

## Notes

- Truncates to n bytes, or extends with zeros. The position does not move.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
f.WriteUtf8( "abcdef" )
f.SetSize( 2 )
f.Close( )
print ReadAllText( p ).Value( )    '' ab

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
