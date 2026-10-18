[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.Position**

# Stream.Position

FsResultI64

## Syntax

```freebasic
Stream.Position( )
```

## Notes

- The current position: Seek( 0, SEEK_FROM_CURRENT ). Fails on a stream that cannot seek.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
m.Seek( 2 )
print m.Position( ).Value( )    '' 2
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
