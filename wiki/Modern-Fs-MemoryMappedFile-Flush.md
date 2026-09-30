[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Flush**

# MemoryMappedFile.Flush

FsResultBool

## Syntax

```freebasic
MemoryMappedFile.Flush( )
```

## Notes

- FsResultBool

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim mm as MemoryMappedFile
mm.Open( p, true )           '' writable

dim as ubyte ptr b = mm.Data( )
b[ 0 ] = asc( "H" )

'' Pushes the dirty pages to disk NOW. Without it the write still lands
'' eventually -- the OS decides when -- so Flush is what makes the
'' change durable at a moment you choose.
print mm.Flush( ).IsOk( )    '' true

mm.Close( )
print ReadAllText( p ).Value( )           '' Hello

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
