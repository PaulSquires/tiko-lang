[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.CanRead**

# Stream.CanRead

Returns true if Read can succeed on this stream.

## Syntax

```freebasic
Stream.CanRead( )
```

## Notes

- Whether Read can succeed. Constant for the life of an open stream; false for Stream itself.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
dim as Stream s
print m.CanRead( ), s.CanRead( )    '' true false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
