[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.Size**

# FileInfo.Size

Returns the size in bytes.

## Syntax

```freebasic
FileInfo.Size( )
```

## Notes

- ulongint

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print Stat( p ).Value( ).Size( )          '' 5 -- "hello"

'' A ULONGINT, so a file above 2 GB does not come back negative

'' On a DIRECTORY the number is whatever the platform reports for the
'' directory entry itself, and is not the size of its contents
print Stat( dir_ ).Value( ).Size( ) >= 0         '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
