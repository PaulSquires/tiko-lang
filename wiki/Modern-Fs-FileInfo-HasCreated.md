[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.HasCreated**

# FileInfo.HasCreated

## Syntax

```freebasic
FileInfo.HasCreated( )
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

'' The guard for CreatedUtc. It reports whether the PLATFORM supplies a
'' creation time at all, not whether this file has one.
print info.HasCreated( )     '' true on Windows

'' Without the guard, a missing value reads as tick 0 -- which is a
'' perfectly valid date, and therefore a silent lie

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
