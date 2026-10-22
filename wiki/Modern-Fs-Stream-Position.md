[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **Stream.Position**

# Stream.Position

Returns the current position, or fails on a stream that cannot seek.

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
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
