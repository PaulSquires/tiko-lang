[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **TextReader**

# TextReader

Holds a reader that decodes lines and text from any Stream, in UTF-8 or UTF-16.

## Syntax

```freebasic
type TextReader
    declare constructor( byref inner as Stream, byval mode as TextErrorMode = TEXT_REPLACE )
    declare constructor( byref inner as Stream, byval enc as TextEncoding, byval mode as TextErrorMode = TEXT_REPLACE )
    declare constructor( byref inner as Stream, byref opts as const TextDetect, byval mode as TextErrorMode = TEXT_REPLACE )
    ReadLine( line ) / ReadToEnd( s ) / Encoding( ) / Detected( )
end type
```

## Notes

- A wrapper does not own what it wraps: it keeps a pointer to the stream it was given, which must outlive it. It cannot be copied.
- Decodes by ReadAllText's rules: a UTF-8, UTF-16LE or UTF-16BE byte-order mark is honoured and dropped; no mark means UTF-8; invalid UTF-8 becomes U+FFFD, or fails with FS_INVALID_DATA under TEXT_STRICT. A file read with ReadAllText and through a TextReader gives the same text.
- A multi-byte sequence split between two reads of the inner stream is joined before it is decoded.
- With an encoding, it reads as ReadAllText( p, enc ) does: that encoding, whatever the data starts with, and only a byte-order mark that matches it is dropped. See [Choosing An Encoding](Category-File-Streams#choosing-an-encoding).
- With a TextDetect, it reads the first opts.PrefixBytes bytes (64 KiB) before its first line and picks the encoding from them: a byte-order mark, else UTF-8 if they are valid UTF-8, else opts.Fallback. Detected( ) returns the encoding it picked.
- Without an encoding, a UTF-32 byte-order mark at the start fails the first ReadLine or ReadToEnd with FS_UNSUPPORTED. With an encoding, the encoding is believed.
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
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
