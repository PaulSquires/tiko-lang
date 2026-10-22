[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **TextWriter**

# TextWriter

Holds a writer that sends text to any Stream as UTF-8, with an optional BOM.

## Syntax

```freebasic
type TextWriter
    declare constructor( byref inner as Stream, byval writeBom as boolean = FALSE )
    as ustring NewLine        '' chr( 13, 10 ) on Windows, chr( 10 ) on Linux
    Write( s ) / WriteLine( [ s ] ) / Flush( )
end type
```

## Notes

- A wrapper does not own what it wraps: it keeps a pointer to the stream it was given, which must outlive it. It cannot be copied.
- UTF-8. With writeBom the byte-order mark is written once, before the first text. A lone surrogate is written as U+FFFD.
- NewLine is platform-native by default. Set it to chr( 10 ) for a file that must be identical on both platforms. Only WriteLine uses it; Write writes its text exactly as given.
- It buffers nothing itself: wrap a BufferedWriter for many small writes.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
dim as TextWriter tw = TextWriter( m )
tw.NewLine = chr( 10 )
tw.WriteLine( "first" )
tw.Write( "second" )
print m.Length( )    '' 12
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
