[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Size**

# MemoryMappedFile.Size

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

ulongint

## Syntax

```freebasic
MemoryMappedFile.Size( )
```

## Notes

- ulongint

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim mm as MemoryMappedFile
mm.Open( p )

print mm.Size( )             '' 5 -- the mapped length, in bytes

'' The bound for Data( ): there is no terminator, so this is the only
'' thing that says where the mapping ends
dim as ubyte ptr b = mm.Data( )
for i as ulongint = 0 to mm.Size( ) - 1
    print chr( b[ i ] );
next
print                        '' hello

mm.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
