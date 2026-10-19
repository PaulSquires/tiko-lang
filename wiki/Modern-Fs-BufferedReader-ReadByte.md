[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **BufferedReader.ReadByte**

# BufferedReader.ReadByte

Reads the next byte; returns false at the end.

## Syntax

```freebasic
BufferedReader.ReadByte( b )
```

## Notes

- TRUE with the next byte in b; FALSE at the end.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "Z" )
dim as BufferedReader br = BufferedReader( m )
dim as ubyte b
print br.ReadByte( b ).Value( ), b    '' true 90
print br.ReadByte( b ).Value( )       '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
