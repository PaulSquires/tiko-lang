[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Close**

# MemoryMappedFile.Close

## Syntax

```freebasic
MemoryMappedFile.Close( )
```

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
mm.Close( )

print mm.IsOpen( )           '' false

'' Closing twice is harmless, and the DESTRUCTOR closes too -- so a
'' mapping that goes out of scope does not leak the handle
mm.Close( )
print mm.IsOpen( )           '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
