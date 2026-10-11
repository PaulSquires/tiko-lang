[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryMappedFile.Size**

# MemoryMappedFile.Size

ulongint

## Syntax

```freebasic
MemoryMappedFile.Size( )
```

## Notes

- ulongint

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

print mm.Size( )             '' 5 -- the mapped length, in bytes

'' The bound for Data( ): there is no terminator, so this is the only
'' thing that says where the mapping ends
dim as uint8 ptr b = mm.Data( )
for i as uint64 = 0 to mm.Size( ) - 1
    print chr( b[ i ] );
next
print                        '' hello

mm.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Locking, Mapping And Watching  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
