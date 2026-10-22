[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **WriteRecord**

# WriteRecord

Writes a value as record n of an open File, growing the file if needed.

## Syntax

```freebasic
WriteRecord( of T )( f, n, r )            '' FsResultBool
```

## Notes

- Writes the sizeof( T ) bytes of r at ( n - 1 ) * sizeof( T ), records counting from 1.
- Writing past the end grows the file, and the records in the gap read as zeros.
- n below 1 fails with FS_INVALID_ARGUMENT. The File must be open for writing.
- T must hold only fixed-size fields: see [RecordFile](Modern-Fs-RecordFile).

## Examples

```freebasic
#import "std/fs"
using fs

type Score field = 1
    player as long
    points as long
end type

dim as File f
f.Open( "scores.dat", OpenOptionsWrite( ) )
dim as Score s
s.player = 3 : s.points = 40
WriteRecord( of Score )( f, 3, s )       '' records 1 and 2 are zeros
print RecordCount( of Score )( f ).Value( )    '' 3
f.Close( )
RemoveFile( "scores.dat" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Records
