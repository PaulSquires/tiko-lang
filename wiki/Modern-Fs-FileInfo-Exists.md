[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.Exists**

# FileInfo.Exists

Returns true if the FileInfo describes something that exists.

## Syntax

```freebasic
FileInfo.Exists( )
```

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim info as FileInfo = Stat( p ).Value( )
print info.Exists( )         '' true

'' A default-constructed FileInfo -- one from a Stat that failed -- says
'' false rather than pretending
dim blank as FileInfo
print blank.Exists( )        '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
