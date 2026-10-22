[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **Stream.CanSeek**

# Stream.CanSeek

Returns true if Seek can succeed on this stream.

## Syntax

```freebasic
Stream.CanSeek( )
```

## Notes

- Whether Seek can succeed. False for a stream that only goes forward.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
print m.CanSeek( )    '' true
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
