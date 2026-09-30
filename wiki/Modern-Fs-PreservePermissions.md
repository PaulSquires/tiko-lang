[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PreservePermissions**

# PreservePermissions

## Syntax

```freebasic
.PreservePermissions
```

## Examples

```freebasic
#import "std/fs"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' A field of CopyOptions, DEFAULT FALSE
CreateDir( PathJoin( dir_, "src" ) )
WriteAllText( PathJoin( dir_, "src", "f.txt" ), "x" )

dim opts as CopyOptions
print opts.PreservePermissions           '' false

opts.PreservePermissions = true
print CopyDir( PathJoin( dir_, "src" ), PathJoin( dir_, "dst" ), opts ).IsOk( )

'' It is SetPosixMode on POSIX and the attribute word on Windows -- the
'' same operation on each platform's OWN model, not a translation
'' between them. There is no portable mode to translate.

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
