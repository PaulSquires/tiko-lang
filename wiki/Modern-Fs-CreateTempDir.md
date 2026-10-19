[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateTempDir**

# CreateTempDir

Creates a uniquely named temporary folder and returns its path; it is not deleted for you.

## Syntax

```freebasic
CreateTempDir( [ prefix ] )
```

## Notes

- CREATES it and returns the path
- `prefix` defaults to `"tiko"`.

## Examples

```freebasic
#import "std/fs"
using fs

'' CREATES the directory and hands back its path. It does not return a
'' name for you to create yourself: the gap between choosing a name and
'' creating it is the classic tmpnam race.
dim r as FsResultUStr = CreateTempDir( "fbdoc" )

print r.IsOk( )              '' true
dim as ustring dir_ = r.Value( )
print IsDir( dir_ )          '' true

'' The name comes from the platform CSPRNG, never from RND.
'' NOTHING IS DELETED AUTOMATICALLY -- remove it yourself.
RemoveDirAll( dir_ )
print Exists( dir_ )         '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
