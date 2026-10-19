[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.ModifiedUtc**

# FileInfo.ModifiedUtc

Returns the last-write time in ticks of 100 ns since 0001-01-01 UTC.

## Syntax

```freebasic
FileInfo.ModifiedUtc( )
```

## Notes

- longint -- ticks, see below

## Examples

```freebasic
#import "std/chrono"
#import "std/fs"
using fs, chrono

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim info as FileInfo = Stat( p ).Value( )

'' TICKS -- the same 100 ns tick std/chrono uses, so it converts
'' straight into an Instant with no arithmetic
print info.ModifiedUtc( ) > 0            '' -1 (true)

dim as Instant when_ = Instant.FromTicks( info.ModifiedUtc( ) )
print when_.IsValid                      '' true

'' UTC, always -- never the local wall clock

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata
