[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.Unlock**

# File.Unlock

FsResultBool

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
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
