[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **Stream.Flush**

# Stream.Flush

Passes any buffered bytes on to where they are going.

## Syntax

```freebasic
Stream.Flush( )
```

## Notes

- Pushes anything the stream buffers to where it goes. A stream that buffers nothing succeeds and does nothing.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
print m.Flush( ).IsOk( )    '' true
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
