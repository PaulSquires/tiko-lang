[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordFile**

# RecordFile

Holds a file of fixed-size records of one type, read and written by number.

## Syntax

```freebasic
type RecordFile( of T )
    Open( p [, recordLen ] ) / Open( p, opts [, recordLen ] )
    GetRecord( n, r ) / PutRecord( n, r ) / Append( r ) / Count( )
    Close( ) / IsOpen( ) / RecordLength( )
    for each r in rf               '' each an FsResult of T
end type
```

## Notes

- Records count from 1. Record n is at ( n - 1 ) * RecordLength( ), which is sizeof( T ) unless Open was given a longer length for a file whose records are padded.
- Reading a record that is not all there, past the end or a short last record, is Ok( false ) with the record untouched, and Count( ) does not count a short record. Writing past the end grows the file; the records in the gap read as zeros.
- T must be plain data: numbers, zstring * n and wstring * n, and types made of those. A ustring, string, pointer or dynamic array is written as the address it holds, which means nothing when it is read back, and nothing checks this for you. Add field = 1 to T for a layout with no padding.
- for each walks records 1, 2, ... while they are whole, yielding Ok( record ) for each. An IO failure is yielded once, as a failure, and ends the walk.
- Close( ) closes the file early; it closes itself when the RecordFile goes out of scope. IsOpen( ) says whether it is open. RecordLength( ) is the length in bytes of one record.
- It owns its File, so do not copy a RecordFile: pass it byref.
- No record locks: [File.Lock](Modern-Fs-File-Lock) locks the whole file.
- Underneath are [ReadRecord](Modern-Fs-ReadRecord), [WriteRecord](Modern-Fs-WriteRecord) and [RecordCount](Modern-Fs-RecordCount), which work on a File you opened yourself.

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
for n as long = 1 to 3
    dim as Score s
    s.player = n : s.points = n * 10
    rf.Append( s )
next
for each r in rf
    print r.Value( ).player; r.Value( ).points
next
rf.Close( )
RemoveFile( "scores.dat" )
''  1 10
''  2 20
''  3 30
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
