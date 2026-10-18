[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **OpenOptionsWrite**

# OpenOptionsWrite

OpenOptions

## Syntax

```freebasic
OpenOptionsWrite( )
```

## Notes

- Write + Create + Truncate: a new, empty file, or an existing one emptied.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
print f.Open( p, OpenOptionsWrite( ) ).IsOk( )    '' true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
