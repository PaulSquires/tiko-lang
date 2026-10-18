[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.Flush**

# Stream.Flush

FsResultBool

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
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
