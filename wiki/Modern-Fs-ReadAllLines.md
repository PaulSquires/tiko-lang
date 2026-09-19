[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReadAllLines**

# ReadAllLines

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultLong -- fills Array( of ustring )

## Syntax

```freebasic
ReadAllLines( p, lines )
```

## Notes

- FsResultLong -- fills Array( of ustring )

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "one" & chr(10) & "two" & chr(10) & "three" )

dim lines_ as Array( of ustring )
dim r as FsResultLong = ReadAllLines( p, lines_ )

print r.IsOk( )              '' true
print r.Value( )             '' 3 -- the count comes back as the value
print lines_[ 1 ]            '' two

'' The line endings are not included, and CRLF and LF both split

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
