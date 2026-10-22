[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordFile.Open**

# RecordFile.Open

Opens a file of records for reading and writing, creating it if it is missing.

## Syntax

```freebasic
RecordFile.Open( p )                      '' FsResultBool
RecordFile.Open( p, recordLen )
RecordFile.Open( p, opts )
RecordFile.Open( p, opts, recordLen )
```

## Notes

- Without opts the file is opened for reading and writing and created if it is missing.
- recordLen is the length in bytes of one record, sizeof( T ) by default. A longer length reads a file whose records are padded: each record is the first sizeof( T ) bytes of its slot, and writing one makes its slot whole.
- A recordLen below sizeof( T ) fails with FS_INVALID_ARGUMENT, and nothing is opened.
- The other failures are File.Open's.

## Examples

```freebasic
#import "std/fs"
using fs

type Score field = 1
    player as long
    points as long
end type

dim as RecordFile( of Score ) rf
print rf.Open( "scores.dat" ).IsOk( ); rf.RecordLength( )    '' true 8
rf.Close( )
dim as RecordFile( of Score ) padded
padded.Open( "scores.dat", 16 )
print padded.RecordLength( )                               '' 16
padded.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
