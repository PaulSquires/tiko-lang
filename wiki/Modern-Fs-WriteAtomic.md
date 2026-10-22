[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **WriteAtomic**

# WriteAtomic

Replaces a file so a reader sees the old or the new contents, never a half-written file.

## Syntax

```freebasic
WriteAtomic( p, s )        '' text, written as UTF-8
WriteAtomic( p, bytes )    '' Array( of ubyte ), written as given
WriteAtomic( p, s, enc [, mode ] )   '' text in a TextEncoding; TEXT_STRICT by default
```

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "config.txt" )
WriteAllText( p, "old" )

'' Writes to a TEMPORARY FILE beside the target, flushes it to the disk
'' and renames it into place, so a reader sees either the whole old file
'' or the whole new one -- never a half-written one -- and once it
'' returns Ok the new contents survive a power cut
print WriteAtomic( p, "new" ).IsOk( )    '' true
print ReadAllText( p ).Value( )          '' new

'' The cost is that the target and the temp file must be on the same
'' volume, which is why the temp file goes beside the target rather than
'' in the system temp directory

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [File Streams](Category-File-Streams)  
**Documented under:** File Operations
