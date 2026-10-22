[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **MemoryStream.ToBytes**

# MemoryStream.ToBytes

Copies every byte held into an Array; returns the count.

## Syntax

```freebasic
MemoryStream.ToBytes( buf )
```

## Notes

- Replaces buf's contents with every byte held, whatever the position. Returns the count.

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
dim as containers.Array( of ubyte ) b
print m.ToBytes( b ), b[0]    '' 3 97
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
