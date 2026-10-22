[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordFile.GetRecord**

# RecordFile.GetRecord

Reads record n into a variable; false when the file has no such record.

## Syntax

```freebasic
RecordFile.GetRecord( n, r )              '' FsResultBool
```

## Notes

- Records count from 1. Ok( true ) fills r.
- Ok( false ) when the file does not hold all of record n, past the end or a short last record; r is left as it was.
- n below 1 fails with FS_INVALID_ARGUMENT.

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
s.points = 99
rf.Append( s )
dim as Score r
print rf.GetRecord( 1, r ).Value( ); r.points    '' true 99
print rf.GetRecord( 5, r ).Value( )              '' false
rf.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
