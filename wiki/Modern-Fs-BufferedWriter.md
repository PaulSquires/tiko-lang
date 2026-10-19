[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **BufferedWriter**

# BufferedWriter

Holds a Stream that gathers small writes and passes them on in large pieces.

## Syntax

```freebasic
type BufferedWriter extends Stream
    declare constructor( byref inner as Stream, byval capacity as long = 65536 )
end type
```

## Notes

- A wrapper does not own what it wraps: it keeps a pointer to the stream it was given, which must outlive it. It cannot be copied.
- Write fills the buffer and passes it on when it is full; a request at least the buffer's size goes through directly after it.
- Flush passes the buffer on and flushes the inner stream. Seek flushes first.
- The destructor flushes and DROPS any error: call Flush to see it.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
scope
    dim as BufferedWriter bw = BufferedWriter( m )
    bw.WriteUtf8( "many " )
    bw.WriteUtf8( "small " )
    bw.WriteUtf8( "writes" )
    print m.Length( )    '' 0 -- all still buffered
end scope
print m.ToUtf8Text( )    '' many small writes
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
