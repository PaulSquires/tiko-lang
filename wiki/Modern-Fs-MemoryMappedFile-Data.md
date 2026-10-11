[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Data**

# MemoryMappedFile.Data

ubyte ptr

## Syntax

```freebasic
MemoryMappedFile.Data( )
```

## Notes

- ubyte ptr

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim mm as MemoryMappedFile
mm.Open( p )

'' A raw pointer to the mapped bytes -- reading it touches the file
'' through the page cache, with no read call at all
dim as uint8 ptr b = mm.Data( )
print b[ 0 ]                 '' 104 -- "h"
print chr( b[ 0 ] ) & chr( b[ 1 ] )       '' he

'' VALID ONLY WHILE THE MAPPING IS OPEN. After Close( ) the pointer
'' dangles, and using it is a page fault rather than an error code.
mm.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
