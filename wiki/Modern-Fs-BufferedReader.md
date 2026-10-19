[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **BufferedReader**

# BufferedReader

Holds a Stream that reads another in large pieces, so many small reads stay fast.

## Syntax

```freebasic
type BufferedReader extends Stream
    declare constructor( byref inner as Stream, byval capacity as long = 65536 )
    ReadByte( b ) / ReadUntil( delim, buf ) / ReadLine( line ) / Peek( n, buf )
end type
```

## Notes

- A wrapper does not own what it wraps: it keeps a pointer to the stream it was given, which must outlive it. It cannot be copied.
- Read serves from the buffer and refills it with ONE inner read when it is empty; a request at least the buffer's size goes straight to the inner stream.
- Seek discards the buffer; a SEEK_FROM_CURRENT offset is measured from where the caller is, not where the inner stream is.
- CanRead and CanSeek are the inner stream's; CanWrite is false.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "first" & chr( 10 ) & "second" )
dim as BufferedReader br = BufferedReader( m )
dim as string ln
while br.ReadLine( ln ).ValueOr( false )
    print ln
wend
'' first
'' second
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
