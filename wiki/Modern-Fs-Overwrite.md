[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Overwrite**

# Overwrite

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
.Overwrite
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' A field of CopyOptions, DEFAULT FALSE: an existing destination file
'' stops the copy instead of being replaced
CreateDir( PathJoin( dir_, "src" ) )
CreateDir( PathJoin( dir_, "dst" ) )
WriteAllText( PathJoin( dir_, "src", "f.txt" ), "new" )
WriteAllText( PathJoin( dir_, "dst", "f.txt" ), "old" )

dim opts as CopyOptions
print opts.Overwrite         '' false

print CopyDir( PathJoin( dir_, "src" ), PathJoin( dir_, "dst" ), opts ).IsOk( )
print ReadAllText( PathJoin( dir_, "dst", "f.txt" ) ).Value( )       '' old

opts.Overwrite = true
CopyDir( PathJoin( dir_, "src" ), PathJoin( dir_, "dst" ), opts )
print ReadAllText( PathJoin( dir_, "dst", "f.txt" ) ).Value( )       '' new

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
