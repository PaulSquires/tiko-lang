[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.IsFile**

# FileInfo.IsFile

Returns true if the path is a regular file.

## Syntax

```freebasic
FileInfo.IsFile( )
```

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print Stat( p ).Value( ).IsFile( )        '' true
print Stat( dir_ ).Value( ).IsFile( )    '' false

'' A REGULAR file: not a directory, not a symlink, not a device

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
