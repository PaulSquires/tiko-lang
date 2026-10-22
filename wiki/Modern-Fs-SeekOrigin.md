[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **SeekOrigin**

# SeekOrigin

Holds where Stream.Seek measures from: the start, the current position or the end.

## Syntax

```freebasic
enum SeekOrigin
    SEEK_FROM_START = 0
    SEEK_FROM_CURRENT = 1
    SEEK_FROM_END = 2
end enum
```

## Notes

- Any other value is FS_INVALID_ARGUMENT.

## Examples

```freebasic
#import "std/fs"
using fs


dim as MemoryStream m = MemoryStream( "0123456789" )
print m.Seek( 3 ).Value( )                        '' 3
print m.Seek( 2, SEEK_FROM_CURRENT ).Value( )     '' 5
print m.Seek( -1, SEEK_FROM_END ).Value( )        '' 9
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
