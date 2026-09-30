[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Exists**

# Exists

boolean

## Syntax

```freebasic
Exists( p )
```

## Notes

- boolean

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print Exists( p )            '' true
print Exists( dir_ )         '' true -- directories too
print Exists( PathJoin( dir_, "nope" ) )         '' false

'' A boolean, not a Result: "I could not tell" and "it is not there"
'' are the same answer to this question. Stat is the one that
'' distinguishes them.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Metadata  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
