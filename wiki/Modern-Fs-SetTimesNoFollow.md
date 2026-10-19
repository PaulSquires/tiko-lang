[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetTimesNoFollow**

# SetTimesNoFollow

Sets a symbolic link's own times, leaving its target alone.

## Syntax

```freebasic
SetTimesNoFollow( p, mtimeUtc [, atimeUtc ] )
SetTimesNoFollow( p, modified, accessed )    '' chrono.Instant
```

## Notes

- SetTimes on a symbolic link itself, leaving its target alone; on anything that is not a link it is SetTimes.
- Ticks of 100 ns since 0001-01-01 UTC, or chrono.Instant values. A time of 0 leaves that one unchanged.

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as chrono.Instant t = chrono.Instant.ParseIso( "2020-01-01T00:00:00Z" )
print SetTimesNoFollow( p, t, t ).IsOk( )    '' true
print Stat( p ).Value( ).Modified( ) = t     '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
