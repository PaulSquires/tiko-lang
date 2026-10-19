[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.WriteBytes**

# Stream.WriteBytes

Writes every byte of an Array.

## Syntax

```freebasic
Stream.WriteBytes( buf )
```

## Notes

- Writes every byte of buf, an Array( of ubyte ), with WriteAll.

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
using fs

dim as containers.Array( of ubyte ) b
b.Push( 104 ) : b.Push( 105 )
dim as MemoryStream m
print m.WriteBytes( b ).IsOk( ), m.ToUtf8Text( )    '' true hi
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
