[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **LStat**

# LStat

Returns a path's FileInfo without following a symbolic link, so a link describes itself.

## Syntax

```freebasic
LStat( p )
```

## Notes

- FsResultInfo -- does NOT follow

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' Identical to Stat EXCEPT that it does not follow a final symlink --
'' it reports the link itself, its own size and its own times.
dim r as FsResultInfo = LStat( p )

print r.IsOk( )              '' true
print r.Value( ).IsFile( )   '' true -- not a link, so the two agree here

'' On an ordinary file Stat and LStat give the same answer; they differ
'' only when the last component IS a link, which is exactly when the
'' difference matters
print Stat( p ).Value( ).Size( ) = r.Value( ).Size( )        '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
