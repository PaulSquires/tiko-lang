[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.Sync**

# File.Sync

Forces the file's data and metadata onto the disk, so a write survives a power cut.

## Syntax

```freebasic
File.Sync( )
```

## Notes

- Writes the file's data and metadata through to the disk (FlushFileBuffers, fsync). What makes a write survive a power cut.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
f.WriteUtf8( "durable" )
print f.Sync( ).IsOk( )    '' true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
