[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **MemoryStream.ToText**

# MemoryStream.ToText

Returns the bytes held decoded in a text encoding, as ReadAllText would read them.

## Syntax

```freebasic
MemoryStream.ToText( enc [, mode ] )     '' FsResultUStr
```

## Notes

- Every byte, whatever the position, decoded in enc. A MemoryStream and a file holding the same bytes give the same text from ToText( enc, mode ) and ReadAllText( p, enc, mode ).
- Believes the encoding: a byte-order mark that matches enc is skipped, and any other bytes are text.
- Bytes that are not valid in enc become U+FFFD, or fail with FS_INVALID_DATA under TEXT_STRICT.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
m.WriteText( "na" & wchr( &hEF ) & "ve", CodePage( 1252 ) )
print len( m.ToText( CodePage( 1252 ) ).Value( ) )    '' 5
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
