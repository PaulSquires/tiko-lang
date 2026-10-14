[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PreserveTimestamps**

# PreserveTimestamps

## Syntax

```freebasic
.PreserveTimestamps
```

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' A field of CopyOptions, DEFAULT FALSE -- a plain copy gets the
'' current time, which is usually what a copy should have
CreateDir( PathJoin( dir_, "src" ) )
WriteAllText( PathJoin( dir_, "src", "f.txt" ), "x" )

dim opts as CopyOptions
print opts.PreserveTimestamps            '' false

opts.PreserveTimestamps = true
print CopyDir( PathJoin( dir_, "src" ), PathJoin( dir_, "dst" ), opts ).IsOk( )

'' Ask for it when the copy is a BACKUP, where the original times are
'' part of what is being preserved

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
