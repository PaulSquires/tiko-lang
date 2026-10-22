[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **RecordCount**

# RecordCount

Returns the number of whole records of a type in an open File.

## Syntax

```freebasic
RecordCount( of T )( f )                 '' FsResultI64
```

## Notes

- The file's size divided by sizeof( T ). A short last record is not counted.

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
rf.Append( s )
rf.Close( )

dim as File f
f.OpenRead( "scores.dat" )
print RecordCount( of Score )( f ).Value( )    '' 2
f.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
