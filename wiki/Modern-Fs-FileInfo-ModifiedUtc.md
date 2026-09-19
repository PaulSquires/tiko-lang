[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileInfo.ModifiedUtc**

# FileInfo.ModifiedUtc

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

longint -- ticks, see below

## Syntax

```freebasic
FileInfo.ModifiedUtc( )
```

## Notes

- longint -- ticks, see below

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim info as FileInfo = Stat( p ).Value( )

'' TICKS -- the same 100 ns tick fb/chrono.bi uses, so it converts
'' straight into an Instant with no arithmetic
print info.ModifiedUtc( ) > 0            '' -1 (true)

#include once "fb/chrono.bi"
dim as Instant when_ = Instant.FromTicks( info.ModifiedUtc( ) )
print when_.IsValid                      '' true

'' UTC, always -- never the local wall clock

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
