[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CopySymlinksAsLinks**

# CopySymlinksAsLinks

## Syntax

```freebasic
.CopySymlinksAsLinks
```

## Examples

```freebasic
#import "std/fs"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' A field of CopyOptions, and the ONE THAT DEFAULTS TRUE: a symlink is
'' copied as a symlink rather than as a copy of what it points at.
dim opts as CopyOptions
print opts.CopySymlinksAsLinks           '' true

'' Set it FALSE to follow links and copy their targets instead, which
'' turns a tree of links into a tree of real files -- and can duplicate
'' a lot of data, or loop, if the links point back into the tree
opts.CopySymlinksAsLinks = false

CreateDir( PathJoin( dir_, "src" ) )
WriteAllText( PathJoin( dir_, "src", "f.txt" ), "x" )
print CopyDir( PathJoin( dir_, "src" ), PathJoin( dir_, "dst" ), opts ).IsOk( )

'' The default is TRUE because a CopyOptions is CONSTRUCTED, not
'' zero-initialised -- a dim'd UDT would come out FALSE

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
