[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **SetTimes**

# SetTimes

Sets a file's modified and accessed times; a time of 0 leaves that one alone.

## Syntax

```freebasic
SetTimes( p, mtimeUtc [, atimeUtc ] )
SetTimes( p, modified, accessed )    '' chrono.Instant values; 0 ticks leaves one alone
```

## Notes

- 0 leaves one alone

## Examples

```freebasic
#import "std/chrono"
#import "std/fs"
using fs, chrono

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )


'' Ticks, in UTC -- the same 100 ns tick std/chrono uses
dim as int64 when_ = Instant.FromUnixSeconds( 1767225600 ).Ticks

print SetTimes( p, when_ ).IsOk( )        '' true
print Stat( p ).Value( ).ModifiedUtc( ) = when_          '' -1 (true)

'' The access time is the optional second argument; 0 leaves it alone
SetTimes( p, when_, when_ )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions
