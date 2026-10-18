[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.CreateNew**

# File.CreateNew

FsResultBool

## Syntax

```freebasic
File.CreateNew( p )
```

## Notes

- Creates p for writing, or fails with FS_ALREADY_EXISTS -- atomically: no other program can create it in between.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
print f.CreateNew( p ).IsOk( )    '' true
f.Close( )
print f.CreateNew( p ).Failure( ).Message( )    '' already exists

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
