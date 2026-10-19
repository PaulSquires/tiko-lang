[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **OpenOptionsRead**

# OpenOptionsRead

Returns the OpenOptions for reading a file that must already exist.

## Syntax

```freebasic
OpenOptionsRead( )
```

## Notes

- Read only, the file must exist.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as File f
print f.Open( p, OpenOptionsRead( ) ).IsOk( )    '' true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
