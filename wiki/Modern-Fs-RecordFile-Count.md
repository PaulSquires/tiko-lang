[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordFile.Count**

# RecordFile.Count

Returns the number of whole records in the file.

## Syntax

```freebasic
RecordFile.Count( )                       '' FsResultI64
```

## Notes

- The file's size divided by RecordLength( ). A short last record is not counted.

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
rf.Append( s )
print rf.Count( ).Value( )    '' 1
rf.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
