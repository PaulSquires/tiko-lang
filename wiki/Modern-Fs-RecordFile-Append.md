[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordFile.Append**

# RecordFile.Append

Writes a variable after the last record and returns its record number.

## Syntax

```freebasic
RecordFile.Append( r )                    '' FsResultI64
```

## Notes

- Writes r as record Count( ) + 1 and returns that number.
- A short last record, one the file holds only part of, is overwritten.

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
print rf.Append( s ).Value( ); rf.Append( s ).Value( )    '' 1 2
rf.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
