[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.CreateNew**

# File.CreateNew

Creates a new file for writing; fails if one is already there.

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
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
