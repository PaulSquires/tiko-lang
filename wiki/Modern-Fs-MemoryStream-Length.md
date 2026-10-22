[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **MemoryStream.Length**

# MemoryStream.Length

Returns the number of bytes held, whatever the position.

## Syntax

```freebasic
MemoryStream.Length( )
```

## Notes

- The number of bytes held, whatever the position.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
print m.Length( )    '' 3
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
