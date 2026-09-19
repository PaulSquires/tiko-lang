[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Glob**

# Glob

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

FsResultLong; fills Array( of ustring )

## Syntax

```freebasic
Glob( pattern, results )
```

## Notes

- FsResultLong; fills Array( of ustring )

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
WriteAllText( PathJoin( dir_, "a.txt" ), "aaa" )
WriteAllText( PathJoin( dir_, "b.txt" ), "bb" )
CreateDir( PathJoin( dir_, "sub" ) )
WriteAllText( PathJoin( dir_, "sub", "c.txt" ), "c" )

'' Expands a pattern against the filesystem, filling an Array
dim hits as Array( of ustring )
dim r as FsResultLong = Glob( PathJoin( dir_, "*.txt" ), hits )

print r.IsOk( )              '' true
print r.Value( )             '' 2 -- a.txt and b.txt, not sub/c.txt

'' ** recurses
dim deep as Array( of ustring )
Glob( PathJoin( dir_, "**", "*.txt" ), deep )
print deep.Count >= 3        '' -1 (true)

'' MatchPattern is the pure text half of this, with no syscalls at all

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
