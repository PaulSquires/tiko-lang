[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TextReader.Encoding**

# TextReader.Encoding

ustring

## Syntax

```freebasic
TextReader.Encoding( )
```

## Notes

- "utf-8", "utf-16le" or "utf-16be" once the first read has looked at the start of the data; "" before that.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "x" )
dim as TextReader tr = TextReader( m )
dim as ustring ln
tr.ReadLine( ln )
print tr.Encoding( )    '' utf-8
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
