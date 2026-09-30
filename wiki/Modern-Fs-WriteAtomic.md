[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WriteAtomic**

# WriteAtomic

## Syntax

```freebasic
WriteAtomic( p, s )
```

## Examples

```freebasic
#import "std/fs"
using FB

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "config.txt" )
WriteAllText( p, "old" )

'' Writes to a TEMPORARY FILE beside the target and renames it into
'' place, so a reader sees either the whole old file or the whole new
'' one -- never a half-written one, even if the process dies mid-write
print WriteAtomic( p, "new" ).IsOk( )    '' true
print ReadAllText( p ).Value( )          '' new

'' The cost is that the target and the temp file must be on the same
'' volume, which is why the temp file goes beside the target rather than
'' in the system temp directory

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
