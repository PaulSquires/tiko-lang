[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.Create**

# File.Create

Opens a file for writing, creating it or emptying it first.

## Syntax

```freebasic
File.Create( p )
```

## Notes

- Write + Create + Truncate.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
print f.Create( p ).IsOk( )    '' true
print f.CanWrite( ), f.CanRead( )    '' true false
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
