[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **ReadRecord**

# ReadRecord

Reads record n of a type from an open File, counting records from 1.

## Syntax

```freebasic
ReadRecord( of T )( f, n, r )             '' FsResultBool
```

## Notes

- Record n is the sizeof( T ) bytes at ( n - 1 ) * sizeof( T ). Ok( true ) fills r with them.
- A record that is not all there, past the end or a short last record, is Ok( false ) and r is left as it was.
- n below 1 fails with FS_INVALID_ARGUMENT; a closed File with FS_CLOSED.
- T must hold only fixed-size fields. See [RecordFile](Modern-Fs-RecordFile) for the rule, and for a type that opens the file and remembers T.

## Examples

```freebasic
#import "std/fs"
using fs

type Score field = 1
    player as long
    points as long
end type

dim as OpenOptions o
o.Read = true : o.Write = true : o.Create = true
dim as File f
f.Open( "scores.dat", o )
dim as Score s
s.player = 7 : s.points = 120
WriteRecord( of Score )( f, 1, s )
dim as Score back
print ReadRecord( of Score )( f, 1, back ).Value( ); back.points    '' true 120
print ReadRecord( of Score )( f, 2, back ).Value( )                 '' false
f.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
