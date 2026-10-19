[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.IsOpen**

# MemoryMappedFile.IsOpen

Returns true while a file is mapped.

## Syntax

```freebasic
MemoryMappedFile.IsOpen( )
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
print mm.IsOpen( )           '' false -- nothing mapped yet

mm.Open( p )
print mm.IsOpen( )           '' true

mm.Close( )
print mm.IsOpen( )           '' false

'' The guard before Data( ) and Size( ), which have nothing to report
'' when the mapping is shut

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching
