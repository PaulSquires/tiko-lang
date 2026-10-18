[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.WriteAt**

# File.WriteAt

FsResultI64

## Syntax

```freebasic
File.WriteAt( pos, buf, n )
```

## Notes

- Writes at pos without moving the position.
- Refused with FS_INVALID_ARGUMENT on a File opened for Append, where the two platforms disagree about where the bytes would go.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "0123456789" )
dim as File f
f.Open( p, OpenOptionsRead( ) )
f.Close( )
dim as OpenOptions o
o.Write = true
f.Open( p, o )
f.WriteAt( 3, @"XY", 2 )
f.Close( )
print ReadAllText( p ).Value( )    '' 012XY56789

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
