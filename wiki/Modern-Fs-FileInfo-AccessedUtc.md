[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.AccessedUtc**

# FileInfo.AccessedUtc

## Syntax

```freebasic
FileInfo.AccessedUtc( )
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

'' Guarded by HasAccessed, like CreatedUtc -- and worth less than it
'' looks: many systems mount with noatime, so it may never advance
if info.HasAccessed( ) then
    print info.AccessedUtc( ) > 0        '' -1 (true)
end if

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
