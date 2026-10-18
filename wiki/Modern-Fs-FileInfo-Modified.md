[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.Modified**

# FileInfo.Modified

chrono.Instant

## Syntax

```freebasic
FileInfo.Modified( )
```

## Notes

- The last-write time as a chrono.Instant. Its ticks are ModifiedUtc( )'s: FileInfo and Instant count the same 100 ns since 0001-01-01 UTC, so nothing is converted.

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
SetTimes( p, chrono.Instant.ParseIso( "2001-02-03T04:05:06Z" ), chrono.Instant.ParseIso( "2001-02-03T04:05:06Z" ) )
print Stat( p ).Value( ).Modified( ).ToIsoString( )    '' 2001-02-03T04:05:06Z

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
