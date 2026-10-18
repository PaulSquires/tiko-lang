[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.ReadExact**

# Stream.ReadExact

FsResultBool

## Syntax

```freebasic
Stream.ReadExact( buf, n )
```

## Notes

- Reads exactly n bytes, calling Read as often as it takes.
- If the data ends first it fails with FS_UNEXPECTED_EOF, and the bytes it did read stay in buf.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
dim as ubyte b( 0 to 3 )
print m.ReadExact( @b(0), 2 ).IsOk( )    '' true
print m.ReadExact( @b(0), 2 ).Failure( ).Message( )    '' unexpected end of data
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
