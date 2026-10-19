[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkOptions.StopOnError**

# WalkOptions.StopOnError

Chooses whether a walk ends at its first error; false by default, so it carries on.

## Syntax

```freebasic
WalkOptions.StopOnError
```

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
WriteAllText( PathJoin( dir_, "a.txt" ), "aaa" )
WriteAllText( PathJoin( dir_, "b.txt" ), "bb" )
CreateDir( PathJoin( dir_, "sub" ) )
WriteAllText( PathJoin( dir_, "sub", "c.txt" ), "c" )

'' A WalkOptions field, DEFAULT FALSE: an unreadable subdirectory
'' yields a failed entry and the walk CONTINUES, so one permission error
'' does not hide every file after it
dim opts as WalkOptions
print opts.StopOnError       '' false

'' Set it TRUE when a partial answer is worse than none -- a backup that
'' silently skips what it cannot read is the classic case
opts.StopOnError = true

for each r in WalkDir( dir_, opts )
    if r.IsOk( ) = false then print "stopped at " & r.Failure( ).Path( )
next
print "done"

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Directories
