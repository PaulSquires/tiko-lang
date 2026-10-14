[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.IsSymlink**

# FileInfo.IsSymlink

## Syntax

```freebasic
FileInfo.IsSymlink( )
```

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' Through Stat this is always FALSE -- Stat follows the link and
'' reports the target. Ask LStat to see the link itself.
print Stat( p ).Value( ).IsSymlink( )    '' false
print LStat( p ).Value( ).IsSymlink( )   '' false -- an ordinary file

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
