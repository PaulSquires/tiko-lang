[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TextReader**

# TextReader

Decoded lines and text from any Stream.

## Syntax

```freebasic
type TextReader
    declare constructor( byref inner as Stream, byval mode as TextErrorMode = TEXT_REPLACE )
    ReadLine( line ) / ReadToEnd( s ) / Encoding( )
end type
```

## Notes

- A wrapper does not own what it wraps: it keeps a pointer to the stream it was given, which must outlive it. It cannot be copied.
- Decodes by ReadAllText's rules: a UTF-8, UTF-16LE or UTF-16BE byte-order mark is honoured and dropped; no mark means UTF-8; invalid UTF-8 becomes U+FFFD, or fails with FS_INVALID_DATA under TEXT_STRICT. A file read with ReadAllText and through a TextReader gives the same text.
- A multi-byte sequence split between two reads of the inner stream is joined before it is decoded.
- Not a Stream: it produces text, not bytes.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "alpha" & chr( 10 ) & "beta" )
dim as TextReader tr = TextReader( m )
dim as ustring ln
while tr.ReadLine( ln ).ValueOr( false )
    print ln
wend
'' alpha
'' beta
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
