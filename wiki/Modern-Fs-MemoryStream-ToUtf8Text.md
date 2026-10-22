[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **MemoryStream.ToUtf8Text**

# MemoryStream.ToUtf8Text

Returns the bytes held decoded as text, the same way ReadAllText decodes a file.

## Syntax

```freebasic
MemoryStream.ToUtf8Text( )
```

## Notes

- Every byte decoded as text by ReadAllText's rules, so a file and a MemoryStream holding the same bytes give the same string: a UTF-8, UTF-16LE or UTF-16BE byte-order mark is honoured and dropped; no mark means UTF-8; invalid UTF-8 becomes U+FFFD.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "caf" & wchr( &hE9 ) )
print len( m.ToUtf8Text( ) )    '' 4
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
