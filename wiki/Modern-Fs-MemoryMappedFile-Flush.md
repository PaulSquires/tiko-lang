[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Flush**

# MemoryMappedFile.Flush

Writes changed mapped bytes to the disk now.

## Syntax

```freebasic
MemoryMappedFile.Flush( )
```

## Notes

- FsResultBool

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim mm as MemoryMappedFile
mm.Open( p, true )           '' writable

dim as uint8 ptr b = mm.Data( )
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
