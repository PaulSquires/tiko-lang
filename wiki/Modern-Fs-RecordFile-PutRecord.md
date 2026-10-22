[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordFile.PutRecord**

# RecordFile.PutRecord

Writes a variable as record n, growing the file when n is past the end.

## Syntax

```freebasic
RecordFile.PutRecord( n, r )              '' FsResultBool
```

## Notes

- Records count from 1. Overwrites record n in place, or grows the file when n is past the end; the records in the gap read as zeros.
- n below 1 fails with FS_INVALID_ARGUMENT. A file opened read-only refuses the write.

## Examples

```freebasic
#import "std/fs"
using fs

type Score field = 1
    player as long
    points as long
end type

dim as RecordFile( of Score ) rf
rf.Open( "scores.dat" )
dim as Score s
s.points = 5
rf.PutRecord( 4, s )
print rf.Count( ).Value( )    '' 4
rf.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
