[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.CanWrite**

# Stream.CanWrite

Returns true if Write can succeed on this stream.

## Syntax

```freebasic
Stream.CanWrite( )
```

## Notes

- Whether Write can succeed. Constant for the life of an open stream; false for Stream itself.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
print m.CanWrite( )    '' true
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
