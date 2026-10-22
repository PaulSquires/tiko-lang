[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.Unlock**

# File.Unlock

Releases this handle's lock; succeeds when none is held.

## Syntax

```freebasic
File.Unlock( )
```

## Notes

- Releases this handle's lock. Ok when none is held.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
f.Lock( )
print f.Unlock( ).IsOk( ), f.Unlock( ).IsOk( )    '' true true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
